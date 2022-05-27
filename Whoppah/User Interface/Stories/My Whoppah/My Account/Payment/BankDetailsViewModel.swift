//
//  EditBankDetailsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 28/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class BankDetailsViewModel {
    
    @Injected private var crashReporter: CrashReporter
    
    struct Inputs {
        let name = BehaviorSubject<String>(value: "")
        let iban = BehaviorSubject<String>(value: "")
        let dob = BehaviorSubject<Date?>(value: nil)
    }

    let inputs = Inputs()

    struct Outputs {
        var title: Observable<String> { _title.asObservable() }
        fileprivate let _title = BehaviorRelay<String>(value: "")

        var name: Observable<String> { _name.asObservable() }
        fileprivate let _name = BehaviorRelay<String>(value: "")

        var iban: Observable<String> { _iban.asObservable() }
        fileprivate let _iban = BehaviorRelay<String>(value: "")
        
        var dob: Observable<Date?> { _dob.asObservable() }
        fileprivate let _dob = BehaviorRelay<Date?>(value: nil)

        var saveEnabled: Observable<Bool> { _saveEnabled.asObservable() }
        fileprivate let _saveEnabled = BehaviorRelay<Bool>(value: false)

        var saving: Observable<Bool> { _saving.asObservable() }
        fileprivate let _saving = PublishRelay<Bool>()
    }

    let outputs = Outputs()

    @Injected private var repo: LegacyUserRepository
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected private var merchant: MerchantService
    
    private var merchantId: UUID?
    private let bag = DisposeBag()
    
    private var user: LegacyMember?
    private var company: LegacyMerchant?

    let coordinator: BankDetailsCoordinator
    
    init(coordinator: BankDetailsCoordinator, maskIban: Bool) {
        self.coordinator = coordinator

        repo.current
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.outputs._name.accept(member.mainMerchant.bank?.accountHolderName ?? "")
                self.inputs.name.onNext(member.mainMerchant.bank?.accountHolderName ?? "")
                
                self.outputs._dob.accept(member.dob)
                self.inputs.dob.onNext(member.dob)
                
                let iban = member.mainMerchant.bank?.accountNumber ?? ""
                let ibanMasked = maskIban ? iban.masked(leavingCharacters: 4) : iban
                self.outputs._iban.accept(ibanMasked)
                self.inputs.iban.onNext(member.mainMerchant.bank?.accountNumber ?? "")
                self.merchantId = member.mainMerchant.id
                
                self.user = member
                self.company = member.mainMerchant
                
            }, onError: { [weak self] error in
                self?.coordinator.showError(error)
            }).disposed(by: bag)
        
        repo.loadCurrentUser()
        
        Observable.combineLatest(inputs.name, inputs.iban)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && IBANValidator.isValid($0.1) }
            .bind(to: outputs._saveEnabled)
            .disposed(by: bag)
        
        outputs._title.accept(R.string.localizable.editBankEnterDetailsTitle())
    }

    func save() {
        guard let id = merchantId, let user = user else { return }
        outputs._saving.accept(true)
        
        var userInput = LegacyMemberInput(member: user)
        userInput.dob = try? inputs.dob.value()
        
        userService.update(id: user.id, member: userInput)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.outputs._saving.accept(false)
            },
            onError: { [weak self] error in
                self?.outputs._saving.accept(false)
                self?.crashReporter.log(error: error)
                self?.coordinator.showError(error)
            }).disposed(by: bag)
        
        guard let name = try? inputs.name.value() else { return }
        guard let iban = try? inputs.iban.value() else { return }
        let input = GraphQL.BankAccountInput(accountNumber: iban, accountHolderName: name)
        merchant.updateBankAccount(id: id, input: input).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.outputs._saving.accept(false)
            self.dismiss()
        }, onError: { [weak self] error in
            self?.coordinator.showError(error)
        }).disposed(by: bag)
    }

    func editDetails() {
        coordinator.editDetails()
    }

    func dismiss() {
        coordinator.dismiss()
    }
}
