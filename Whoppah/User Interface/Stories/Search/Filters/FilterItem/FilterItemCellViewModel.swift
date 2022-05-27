//
//  FilterItemCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class FilterItemCellViewModel {
    private let attribute: FilterAttribute
    var isSelected: Bool {
        didSet {
            _itemClick.onNext(attribute)
        }
    }

    private var _itemClick = PublishSubject<FilterAttribute>()
    public var itemClick: Observable<FilterAttribute> {
        _itemClick.asObserver()
    }

    var bag: DisposeBag

    enum Style {
        case checkbox
        case radio
    }

    let selectionStyle: Style = .checkbox

    init(attribute: FilterAttribute, bag: DisposeBag, selected: Bool) {
        self.attribute = attribute
        isSelected = selected
        self.bag = bag
    }

    var title: Observable<String?> {
        attribute.title.asObservable()
    }
}
