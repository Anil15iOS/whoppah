//
//  RegistrationViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 02/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import WhoppahRepository
import Resolver

// Temporary, will be refactored soon
public enum SocialNetwork {
    case facebook
    case google
    case apple
}

class RegistrationViewModel {
    @Injected private var crashReporter: CrashReporter
    @Injected private var eventTracking: EventTrackingService
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var merchant: MerchantService
    @LazyInjected private var merchantRepository: MerchantRepository
    
    var step: RegistrationStep {
        didSet {
            switch step {
            case .email:
                outputs._profileName.accept((try? inputs.profileName.value()) ?? "")
                outputs._email.accept((try? inputs.email.value()) ?? "")
            case .merchantDetail:
                outputs._phone.accept((try? inputs.phone.value()) ?? "")
                outputs._companyName.accept((try? inputs.companyName.value()) ?? "")
            case .merchantContact:
                outputs._firstName.accept((try? inputs.firstName.value()) ?? "")
                outputs._lastName.accept((try? inputs.lastName.value()) ?? "")
            case .merchantAddress:
                outputs._postcode.accept((try? inputs.postcode.value()) ?? "")
                outputs._country.accept((try? inputs.country.value()) ?? Country.netherlands)
                outputs._city.accept((try? inputs.city.value()) ?? "")
                outputs._line1.accept((try? inputs.line1.value()) ?? "")
                outputs._line2.accept((try? inputs.line2.value()) ?? "")
            default: break
            }
        }
    }

    var merchantType: GraphQL.MerchantType
    var allowSocial: Bool { merchantType == .individual }

    private var originalMember: LegacyMember?
    private let isNewUser: Bool
    private var company: LegacyMerchantInput?
    private var member: LegacyMemberInput?
    var isMerchant: Bool { merchantType == .business }
    let coordinator: RegistrationCoordinator
    private let bag = DisposeBag()

    struct Inputs {
        let firstName = BehaviorSubject<String>(value: "")
        let lastName = BehaviorSubject<String>(value: "")
        let profileName = BehaviorSubject<String>(value: "")
        let email = BehaviorSubject<String>(value: "")
        let password = BehaviorSubject<String>(value: "")
        let companyName = BehaviorSubject<String>(value: "")
        let phone = BehaviorSubject<String>(value: "")
        let line1 = BehaviorSubject<String>(value: "")
        let line2 = BehaviorSubject<String>(value: "")
        let postcode = BehaviorSubject<String>(value: "")
        let city = BehaviorSubject<String>(value: "")
        let country = BehaviorSubject<Country>(value: .netherlands)
    }

    let inputs = Inputs()
    struct Outputs {
        var firstName: Observable<String> { _firstName.asObservable() }
        fileprivate let _firstName = BehaviorRelay<String>(value: "")

        var lastName: Observable<String> { _lastName.asObservable() }
        fileprivate let _lastName = BehaviorRelay<String>(value: "")

        var profileName: Observable<String> { _profileName.asObservable() }
        fileprivate let _profileName = BehaviorRelay<String>(value: "")

        var email: Observable<String> { _email.asObservable() }
        fileprivate let _email = BehaviorRelay<String>(value: "")

        var password: Observable<String> { _password.asObservable() }
        fileprivate let _password = BehaviorRelay<String>(value: "")

        var companyName: Observable<String> { _companyName.asObservable() }
        fileprivate let _companyName = BehaviorRelay<String>(value: "")

        var phone: Observable<String> { _phone.asObservable() }
        fileprivate let _phone = BehaviorRelay<String>(value: "")

        var line1: Observable<String> { _line1.asObservable() }
        fileprivate let _line1 = BehaviorRelay<String>(value: "")

        var line2: Observable<String> { _line2.asObservable() }
        fileprivate let _line2 = BehaviorRelay<String>(value: "")

        var postcode: Observable<String> { _postcode.asObservable() }
        fileprivate let _postcode = BehaviorRelay<String>(value: "")

        var city: Observable<String> { _city.asObservable() }
        fileprivate let _city = BehaviorRelay<String>(value: "")

        var country: Observable<Country> { _country.asObservable() }
        fileprivate let _country = BehaviorRelay<Country>(value: .netherlands)

        var loading: Observable<Bool> { _loading.asObservable() }
        fileprivate let _loading = PublishRelay<Bool>()
    }

    var numberOfSteps: Int { RegistrationStep.numSteps(type: merchantType, isNewUser: isNewUser) }
    var currentStep: Int { RegistrationStep.stepValue(step, isNewUser: isNewUser) }

    var actionButtonText: String {
        if currentStep + 1 == numberOfSteps {
            return R.string.localizable.commonNextLastStepButton()
        }
        if currentStep < numberOfSteps {
            return R.string.localizable.commonNextStepButton()
        }
        guard isNewUser else {
            return R.string.localizable.commonButtonSave()
        }

        return R.string.localizable.auth_sign_up2_btn_sign_up()
    }

    let outputs = Outputs()

    init(coordinator: RegistrationCoordinator, step: RegistrationStep = .accountChooser) {
        self.coordinator = coordinator
        self.step = step

        switch step {
        case .merchantContact, .merchantDetail, .merchantAddress:
            isNewUser = false
            merchantType = .business
            loadUser()
        default:
            merchantType = .individual
            isNewUser = true
        }
        
        eventTracking.trackSignUpStart()
    }

    private func loadUser(updateUser: Bool = false) {
        user.active.compactMap { $0 }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.originalMember = member
                self.member = LegacyMemberInput(member: member)
                let company = member.mainMerchant
                self.company = LegacyMerchantInput(merchant: company)
                if updateUser {
                    self.syncUser()
                } else {
                    self.onCompanyLoaded(member.mainMerchant)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.crashReporter.log(error: error)
                self.coordinator.showError(error)
            }).disposed(by: bag)

        user.getActive()
    }

    private func syncUser() {
        guard var member = member, let memberId = member.id else { return }
        guard var company = company else { return }
        guard let profileName = try? inputs.profileName.value() else { return }
        guard let businessName = try? inputs.companyName.value() else { return }
        guard let email = try? inputs.email.value() else { return }
        guard let line1 = try? inputs.line1.value() else { return }
        guard let line2 = try? inputs.line2.value() else { return }
        guard let city = try? inputs.city.value() else { return }
        guard let postcode = try? inputs.postcode.value() else { return }
        guard let country = try? inputs.country.value() else { return }
        let primaryAddress = originalMember?.mainMerchant.address.first
        let addressId = primaryAddress?.id
        let address = LegacyAddressInput(id: addressId, line1: line1, line2: line2, postalCode: postcode, city: city, country: country.rawValue)

        member.givenName = try? inputs.firstName.value()
        member.familyName = try? inputs.lastName.value()

        let phone = try? inputs.phone.value()
        company.name = profileName
        company.businessName = businessName
        company.email = email
        company.phone = phone

        outputs._email.accept(email)
        outputs._loading.accept(true)

        var addressObserver: Observable<UUID?> = Observable.just(nil)
        if isMerchant {
            if primaryAddress != nil {
                addressObserver = merchant.updateAddress(id: company.id, address: address).map { $0.id }
            } else {
                addressObserver = merchant.addAddress(id: company.id, address: address).map { $0.id }
            }
        }

        // Update the member after all others as it is the one that triggers a change in observers...I think
        Observable.zip(addressObserver, merchant.update(company))
            .flatMap { _ in self.user.update(id: memberId, member: member) }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.outputs._loading.accept(false)
                if self.isNewUser {
                    self.dismiss()
                    self.coordinator.requestNotificationPermission()
                } else {
                    self.coordinator.onProfileEdited {
                        self.coordinator.requestNotificationPermission()
                    }
                }

                // We really really shouldn't need to do this
                // But the apollo cache sometimes refuses to update
                // Then when we land back into the home screen and try to create an ad
                // For some reason the cache is out of date (even though it should be updating)
                // So now we force an update here after all these updates are completed
                self.user.getActive()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.outputs._loading.accept(false)
                self.crashReporter.log(error: error)
                self.coordinator.showError(error)
            }).disposed(by: bag)
    }

    private func onCompanyLoaded(_ merchant: LegacyMerchant) {
        merchantType = merchant.type

        outputs._companyName.accept(merchant.businessName ?? "")
        inputs.companyName.onNext(outputs._companyName.value)

        outputs._email.accept(merchant.email ?? "")
        inputs.email.onNext(outputs._email.value)

        outputs._phone.accept(merchant.phone ?? "")
        inputs.phone.onNext(outputs._phone.value)

        outputs._profileName.accept(merchant.name)
        inputs.profileName.onNext(outputs._profileName.value)

        if let address = merchant.address.first {
            outputs._line1.accept(address.line1)
            inputs.line1.onNext(outputs._line1.value)

            outputs._line2.accept(address.line2 ?? "")
            inputs.line2.onNext(outputs._line2.value)

            outputs._city.accept(address.city)
            inputs.city.onNext(outputs._city.value)

            outputs._postcode.accept(address.postalCode)
            inputs.postcode.onNext(outputs._postcode.value)

            let country = Country(rawValue: address.country.uppercased()) ?? .netherlands
            outputs._country.accept(country)
            inputs.country.onNext(outputs._country.value)
        }

        guard let member = member else { return }
        outputs._firstName.accept(member.givenName ?? "")
        inputs.firstName.onNext(outputs._firstName.value)

        outputs._lastName.accept(member.familyName ?? "")
        inputs.lastName.onNext(outputs._lastName.value)
    }

    private func register() {
        guard let email = try? inputs.email.value() else { return }
        guard let password = try? inputs.password.value() else { return }
        outputs._loading.accept(true)
//        auth.signUp(email: email,
//                             password: password,
//                             isMerchant: isMerchant) { [weak self] result in
//            guard let self = self else { return }
//            self.outputs._loading.accept(false)
//            switch result {
//            case .success:
//                self.eventTracking.trackSignUpSuccess()
//                self.loadUser(updateUser: true)
//            case let .failure(error):
//                self.showRegistrationError(error)
//            }
//        }
    }

    func register(via network: SocialNetwork) {
        coordinator.register(via: network) { cancelled in
            guard !cancelled else {
                self.eventTracking.trackSignUpSuccess()
                self.outputs._loading.accept(false)
                return
            }
            self.coordinator.requestNotificationPermission()
        }
    }

    func dismiss() {
        coordinator.dismiss()
    }

    func next() {
        guard let next = step.next(type: merchantType) else {
            if isNewUser {
                register()
            } else {
                loadUser(updateUser: true)
            }
            return
        }
        step = next
        coordinator.start(step: next, type: merchantType)
    }

    private func showRegistrationError(_ error: Error) {
        DispatchQueue.main.async {
            if let http = error as? HTTPError {
                if case let .statusCode(_, code, _) = http, code == 400 {
                    let userError = UserMessageError(message: R.string.localizable.authRegistrationFailedExisting())
                    self.coordinator.showError(userError)
                    return
                }
            }
            self.crashReporter.log(error: error)
            self.coordinator.showError(error)
        }
    }
}
