//
//  BrandCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class AdAttributeCellViewModel {
    let attribute: AdAttribute
    var isSelected: Bool
    var allowMulti: Bool
    let onSelect: (() -> Void)?
    init(attribute: AdAttribute, selected: Bool, allowMulti: Bool, onSelect: (() -> Void)? = nil) {
        self.attribute = attribute
        isSelected = selected
        self.onSelect = onSelect
        self.allowMulti = allowMulti
    }

    var title: Observable<String> {
        Observable.just(attribute.localizedTitle)
    }

    func onAttributeSelected() {
        isSelected = !isSelected
        onSelect?()
    }
}
