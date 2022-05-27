//
//  DeliveryCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 28/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class DeliveryCellViewModel {
    private let _address: LegacyAddress
    var onClick = PublishSubject<LegacyAddress>()
    var selected = BehaviorSubject<Bool>(value: false)
    private let bag = DisposeBag()

    init(address: LegacyAddress, bag: DisposeBag) {
        _address = address
        selected.subscribe(onNext: { [weak self] selected in
            guard let self = self else { return }
            if selected {
                self.onClick.onNext(self._address)
            }
        }).disposed(by: bag)
    }

    var id: UUID {
        _address.id
    }

    var addressLine1: String {
        let street = _address.line1
        let building = _address.line2 != nil ? "\(_address.line2!)" : "-"
        return "\(street) \(building)".trim()
    }

    var addressLine2: String {
        let city = _address.city
        let zip = _address.postalCode
        return "\(zip) \(city)".trim()
    }
}
