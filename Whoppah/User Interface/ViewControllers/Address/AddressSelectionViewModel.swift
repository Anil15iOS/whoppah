//
//  AddressSelectionViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 28/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

class AddressSelectionViewModel {
    struct Inputs {
        let selectedAddress = BehaviorSubject<LegacyAddress?>(value: nil)
    }

    struct Outputs {
        var addresses: Observable<[DeliveryCellViewModel]> {
            _addresses.asObservable()
        }

        fileprivate let _addresses = BehaviorRelay<[DeliveryCellViewModel]>(value: [])
        var selectedAddress: Observable<LegacyAddress?> {
            _selectedAddress.asObservable()
        }

        fileprivate let _selectedAddress = BehaviorRelay<LegacyAddress?>(value: nil)
        let error = PublishSubject<Error>()
    }

    let outputs = Outputs()
    let inputs = Inputs()

    @Injected private var repo: LegacyUserRepository
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var merchant: MerchantService

    private let bag = DisposeBag()
    private var addresses = [LegacyAddress]()
    private var selectedItem: DeliveryCellViewModel? {
        willSet {
            selectedItem?.selected.onNext(false)
        }
        didSet {
            selectedItem?.selected.onNext(true)
        }
    }

    init(selectedAddress: LegacyAddress?) {
        inputs.selectedAddress.subscribe(onNext: { [weak self] address in
            guard let self = self, !self.addresses.isEmpty else { return }
            if let index = self.addresses.firstIndex(where: { $0.id == address?.id }) {
                self.selectedItem = self.outputs._addresses.value[index]
                self.outputs._selectedAddress.accept(address)
            }
        }).disposed(by: bag)

        repo.current.compactMap { $0 }.subscribe(onNext: { [weak self] member in
            guard let self = self else { return }
            self.addresses = member.mainMerchant.address
            if let selected = selectedAddress {
                // It's possible the user has deleted the address already
                // So if they have then tack on the selected address to the end of the list
                if !self.addresses.contains(where: { $0.id == selected.id }) {
                    self.addresses.append(selected)
                }
            }
            self.generateAddressVMs(selectedAddress: selectedAddress?.id)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.outputs.error.onNext(error)
        }).disposed(by: bag)
        repo.loadCurrentUser()
    }

    func onAddressSelected(_ path: IndexPath, model _: DeliveryCellViewModel) {
        selectedItem = outputs._addresses.value[path.row]
    }

    func addAddress(address: LegacyAddressInput) {
        guard let id = user.current?.merchantId else { assertionFailure(); return }
        merchant.addAddress(id: id, address: address).subscribe(onNext: { _ in }).disposed(by: bag)
    }

    private func generateAddressVMs(selectedAddress: UUID?) {
        var vms = [DeliveryCellViewModel]()

        let selectedId = selectedAddress ?? addresses.first?.id
        for address in addresses {
            let isSelected = address.id == selectedId
            let vm = DeliveryCellViewModel(address: address as LegacyAddress, bag: bag)
            vm.onClick.subscribe(onNext: { [weak self] address in
                guard let self = self else { return }
                self.outputs._selectedAddress.accept(address)
            }).disposed(by: bag)
            if isSelected {
                selectedItem = vm
                outputs._selectedAddress.accept(address as LegacyAddress)
            }
            vms.append(vm)
        }

        outputs._addresses.accept(vms)
    }
}
