//
//  ProductBlockViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 07/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class ProductBlockViewModel: BlockViewModel {
    private let block: ProductBlock
    private let products: [WhoppahCore.Product]
    private var _productClick = PublishSubject<WhoppahCore.Product>()
    public var productClick: Observable<WhoppahCore.Product> {
        _productClick.asObserver()
    }

    private var _showAllClick = PublishSubject<ProductBlock>()
    public var showAllClick: Observable<ProductBlock> {
        _showAllClick.asObserver()
    }

    private let bag = DisposeBag()

    init(block: ProductBlock) {
        self.block = block
        products = block.blockProducts
    }

    var title: Observable<String?> {
        observedLocalizedString(block.titleKey)
    }

    var buttonTitle: Observable<String?> {
        if block.link == nil { return Observable.just(nil) }
        return observedLocalizedString(block.buttonKey, placeholder: R.string.localizable.common_btn_show_all())
    }

    var allButtonEnabled: Observable<Bool> {
        Observable.just(block.link != nil)
    }

    // MARK: Datasource

    func numItems() -> Int {
        products.count
    }

    func cell(atIndex index: Int) -> AdViewModel? {
        guard index < products.count else { return nil }
        let cell = AdViewModel(product: products[index])
        _productClick.bind(to: cell.productClick).disposed(by: bag)
        return cell
    }

    // MARK: Actions

    func cellClicked(atIndex index: Int) {
        guard index < products.count else { return }
        _productClick.onNext(products[index])
    }

    func showAllClicked() {
        _showAllClick.onNext(block)
    }
}
