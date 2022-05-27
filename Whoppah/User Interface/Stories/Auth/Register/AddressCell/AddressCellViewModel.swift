//
//  AddressCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 16/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

struct AddressCellEdit {
    let address: LegacyAddressInput
    let canDelete: Bool
}

class AddressCellViewModel {
    private let address: LegacyAddressInput
    struct Outputs {
        var editClicked: Observable<AddressCellEdit> { _editClicked.asObservable() }
        fileprivate let _editClicked = PublishRelay<AddressCellEdit>()

        var deleteClicked: Observable<LegacyAddressInput> { _deleteClicked.asObservable() }
        fileprivate let _deleteClicked = PublishRelay<LegacyAddressInput>()
    }

    let outputs = Outputs()
    init(address: LegacyAddressInput) {
        self.address = address
    }

    var id: UUID? {
        address.id
    }

    var canDelete = BehaviorSubject<Bool>(value: false)

    var addressText: String {
        address.line1
    }

    var postCodeCityText: String {
        address.postalCode + " " + address.city
    }

    func editAddress() {
        let canDeleteCell = try? canDelete.value()
        outputs._editClicked.accept(AddressCellEdit(address: address, canDelete: canDeleteCell ?? false))
    }

    func deleteAddress() {
        outputs._deleteClicked.accept(address)
    }
}
