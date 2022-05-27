//
//  ContactInfoViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 16/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver

class ContactInfoViewModel {
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected fileprivate var merchant: MerchantService
    @Injected fileprivate var crashReporter: CrashReporter
    private let coordinator: ContactInfoCoordinator

    private var user: LegacyMember?
    private var company: LegacyMerchant?
    private let bag = DisposeBag()

    struct Inputs {
        let givenName = BehaviorSubject<String>(value: "")
        let familyName = BehaviorSubject<String>(value: "")
        let businessName = BehaviorSubject<String>(value: "")
        let companyName = BehaviorSubject<String>(value: "")
        let phone = BehaviorSubject<String>(value: "")
        let email = BehaviorSubject<String>(value: "")
        let website = BehaviorSubject<String>(value: "")
        let vatId = BehaviorSubject<String>(value: "")
        let taxId = BehaviorSubject<String>(value: "")
    }

    let inputs = Inputs()

    struct Outputs {
        var isBusiness: Observable<Bool> { _isBusiness.asObservable() }
        fileprivate let _isBusiness = BehaviorRelay<Bool>(value: false)

        var isSaving: Observable<Bool> { _isSaving.asObservable() }
        fileprivate let _isSaving = BehaviorRelay<Bool>(value: false)

        var saveButton: Observable<Bool> { _saveButton.asObservable() }
        fileprivate let _saveButton = BehaviorRelay<Bool>(value: false)

        var givenName: Observable<TextFieldText> { _givenName.asObservable() }
        fileprivate let _givenName = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var familyName: Observable<TextFieldText> { _familyName.asObservable() }
        fileprivate let _familyName = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var email: Observable<TextFieldText?> { _email.asObservable() }
        fileprivate let _email = BehaviorRelay<TextFieldText?>(value: TextFieldText(title: ""))

        var phone: Observable<TextFieldText?> { _phone.asObservable() }
        fileprivate let _phone = BehaviorRelay<TextFieldText?>(value: TextFieldText(title: ""))

        var website: Observable<TextFieldText?> { _website.asObservable() }
        fileprivate let _website = BehaviorRelay<TextFieldText?>(value: TextFieldText(title: ""))

        var vatId: Observable<String?> { _vatId.asObservable() }
        fileprivate let _vatId = BehaviorRelay<String?>(value: "")

        var taxId: Observable<String?> { _taxId.asObservable() }
        fileprivate let _taxId = BehaviorRelay<String?>(value: "")

        var businessName: Observable<TextFieldText> { _businessName.asObservable() }
        fileprivate let _businessName = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var companyName: Observable<TextFieldText> { _companyName.asObservable() }
        fileprivate let _companyName = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var addresses: Observable<[AddressCellViewModel]> { _addresses.asObservable() }
        fileprivate let _addresses = BehaviorRelay<[AddressCellViewModel]>(value: [])
    }

    let outputs = Outputs()

    init(coordinator: ContactInfoCoordinator) {
        self.coordinator = coordinator

        outputs._saveButton.accept(false)
        
        if let member = userService.current {
            guard !self.outputs._isSaving.value else { return }
            self.user = member
            self.company = member.mainMerchant
            self.outputs._isBusiness.accept(self.showCompanyView())

            var viewModels = [AddressCellViewModel]()
            member.mainMerchant.address.forEach { address in
                viewModels.append(self.getCellViewModel(address))
            }
            self.outputs._addresses.accept(viewModels)
            self.outputs._saveButton.accept(true)
            self.setupData()
        }
    }

    func load() {}

    func save(completion: @escaping (() -> Void)) {
        guard let givenName = try? inputs.givenName.value() else { return }
        guard let familyName = try? inputs.familyName.value() else { return }
        guard let email = try? inputs.email.value() else { return }
        guard let company = company, let user = user else { return }
        let phone = try? inputs.phone.value()
        let businessName = try? inputs.businessName.value()
        let name = try? inputs.companyName.value()
        let website = try? inputs.website.value()
        let vatId = try? inputs.vatId.value()
        let taxId = try? inputs.taxId.value()

        guard !email.isEmpty else {
            outputs._email.accept(TextFieldText(error: R.string.localizable.commonMissingEmail()))
            return
        }

        guard !givenName.isEmpty else {
            outputs._givenName.accept(TextFieldText(error: R.string.localizable.commonMissingFirstName()))
            return
        }

        guard !familyName.isEmpty else {
            outputs._familyName.accept(TextFieldText(error: R.string.localizable.commonMissingLastName()))
            return
        }

        guard let enteredPhone = phone, !enteredPhone.isEmpty else {
            outputs._phone.accept(TextFieldText(error: R.string.localizable.commonMissingPhoneNumber()))
            return
        }

        guard let profile = name, !profile.isEmpty else {
            outputs._companyName.accept(TextFieldText(error: R.string.localizable.commonMissingProfileName()))
            return
        }

        if let site = website, !site.isEmpty, !site.isValidURL {
            outputs._website.accept(TextFieldText(error: R.string.localizable.setProfileInvalidWebsiteUrl()))
            return
        }

        if showCompanyView() {
            guard let business = businessName, !business.isEmpty else {
                outputs._businessName.accept(TextFieldText(error: R.string.localizable.commonMissingCompanyName()))
                return
            }
        }

        var userInput = LegacyMemberInput(member: user)
        userInput.givenName = givenName
        userInput.familyName = familyName
        userInput.email = email
    
        var merchantInput = LegacyMerchantInput(merchant: company)

        merchantInput.phone = phone ?? merchantInput.phone
        // Assume the user email if no company email is set
        merchantInput.email = email

        merchantInput.name = name ?? merchantInput.name
        merchantInput.businessName = businessName ?? merchantInput.businessName
        merchantInput.url = website ?? merchantInput.url
        merchantInput.vatId = vatId ?? merchantInput.vatId
        merchantInput.taxId = taxId ?? merchantInput.taxId

        outputs._isSaving.accept(true)
        userService.update(id: user.id, member: userInput)
            .flatMap { _ in self.merchant.update(merchantInput) }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.outputs._isSaving.accept(false)
                completion()
            }, onError: { [weak self] error in
                self?.outputs._isSaving.accept(false)
                self?.crashReporter.log(error: error)
                self?.coordinator.showError(error)
            }).disposed(by: bag)
    }

    func addAddress() {
        coordinator.addAddress(delegate: self)
    }

    // MARK: Private

    private func showCompanyView() -> Bool {
        company?.type == .business
    }

    private func editCell(_ data: AddressCellEdit) {
        coordinator.editAddress(data: data, delegate: self)
    }

    private func getCellViewModel(_ address: LegacyAddress) -> AddressCellViewModel {
        let vm = AddressCellViewModel(address: LegacyAddressInput(address: address))
        vm.outputs.editClicked.subscribe(onNext: { [weak self] viewModel in
            self?.editCell(viewModel)
        }).disposed(by: bag)
        vm.outputs.deleteClicked.subscribe(onNext: { [weak self] viewModel in
            self?.deleteCell(viewModel)
        }).disposed(by: bag)
        outputs._addresses.map { $0.count > 1 }.bind(to: vm.canDelete).disposed(by: bag)
        return vm
    }

    private func deleteCell(_ address: LegacyAddressInput) {
        guard let addressId = address.id, let merchantId = user?.merchantId else { return }
        merchant.removeAddress(id: merchantId, addressId: addressId)
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.crashReporter.log(error: error)
                let textError = UserMessageError(message: R.string.localizable.set_profile_personal_delete_address_error())
                self?.coordinator.showError(textError)
            }).disposed(by: bag)
    }

    private func setupData() {
        guard let member = user, let company = company else { return }

        outputs._businessName.accept(TextFieldText(title: company.businessName ?? ""))
        inputs.businessName.onNext(company.businessName ?? "")

        outputs._companyName.accept(TextFieldText(title: company.name))
        inputs.companyName.onNext(company.name)

        outputs._website.accept(TextFieldText(title: company.url ?? ""))
        inputs.website.onNext(company.url ?? "")

        outputs._vatId.accept(company.vatId)
        inputs.vatId.onNext(company.vatId ?? "")

        outputs._taxId.accept(company.taxId)
        inputs.taxId.onNext(company.taxId ?? "")

        outputs._phone.accept(TextFieldText(title: company.phone ?? ""))
        inputs.phone.onNext(company.phone ?? "")

        outputs._email.accept(TextFieldText(title: member.email))
        inputs.email.onNext(member.email)

        outputs._givenName.accept(TextFieldText(title: member.givenName))
        inputs.givenName.onNext(member.givenName)

        outputs._familyName.accept(TextFieldText(title: member.familyName))
        inputs.familyName.onNext(member.familyName)
    }
}

// MARK: - AddEditAddressViewControllerDelegate

extension ContactInfoViewModel: AddEditAddressViewControllerDelegate {
    func addEditAddressViewController(didDelete address: LegacyAddressInput) {
        deleteCell(address)
    }

    func addEditAddressViewController(didSave address: LegacyAddressInput) {
        guard let id = user?.merchantId else { assertionFailure(); return }

        if address.id == nil {
            merchant.addAddress(id: id, address: address)
                .observeOn(MainScheduler.instance)
                .subscribe(onError: { [weak self] error in
                    guard let self = self else { return }
                    self.crashReporter.log(error: error)
                    self.coordinator.showError(error)
                }).disposed(by: bag)
        } else {
            merchant.updateAddress(id: id, address: address)
                .observeOn(MainScheduler.instance)
                .subscribe(onError: { [weak self] error in
                    guard let self = self else { return }
                    self.crashReporter.log(error: error)
                    self.coordinator.showError(error)
                }).disposed(by: bag)
        }
    }
}
