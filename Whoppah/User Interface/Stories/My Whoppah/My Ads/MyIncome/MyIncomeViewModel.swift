//
//  MyIncomeViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 03/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

struct MyIncomeCellData {
    let ID: UUID
    let status: String
    let statusColorHex: String // Hex so we don't image UIKit into the ViewModel
    let price: String
    let date: String
    let thumbUrl: URL?
}

class MyIncomeViewModel {
    private let repo: OrderRepository

    private let dateFormatter = DateFormatter()
    private let bag = DisposeBag()
    
    @Injected private var userService: WhoppahCore.LegacyUserService

    struct Outputs {
        var ads: Observable<[MyIncomeCellData]> {
            _ads.asObservable()
        }

        fileprivate let _ads = BehaviorRelay<[MyIncomeCellData]>(value: [])
        let error = PublishSubject<Error>()
    }

    let outputs = Outputs()

    init(repo: OrderRepository) {
        self.repo = repo

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        _ = repo.items.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(orders):
                self.repo.applyItems(list: orders)
                var existing = self.outputs._ads.value
                if self.itemsPager.isFirstPage() {
                    existing.removeAll()
                }
                let newItems = orders.compactMap { (adVM) -> MyIncomeCellData? in
                    self.getCellData(order: adVM)
                }
                existing.append(contentsOf: newItems)
                self.outputs._ads.accept(existing)
            case let .failure(error):
                self.outputs.error.onNext(error)
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.outputs.error.onNext(error)
        }).disposed(by: bag)
        loadItems()
    }
}

// MARK: Datasource

extension MyIncomeViewModel {
    func loadItems() {
        guard let id = userService.current?.merchantId else { return }
        repo.load(merchantId: id)
    }

    func loadMoreItems() -> Bool {
        let hasMore = repo.loadMore()
        return hasMore
    }

    var itemsPager: PagedView {
        repo.pager
    }

    func getNumberOfItems() -> Int {
        repo.numitems()
    }

    private func getCellData(order: GraphQL.OrdersQuery.Data.Order.Item) -> MyIncomeCellData? {
        let product = order.product
        var date = ""
        if let auctionDate = order.product.auction?.endDate {
            date = dateFormatter.string(from: auctionDate.date)
        }
        if let soldDate = order.endDate {
            date = dateFormatter.string(from: soldDate.date)
        }

        let price = PriceInput(currency: order.currency, amount: order.payout)
        var statusText = order.state.title
        let blueTextColor = "#8AA8D9"
        let blackTextColor = "#181B1E"
        let redInvalidTextColor = "#BC0728"

        var statusColor = blackTextColor
        switch order.state {
        case .new:
            statusColor = blueTextColor
        case .disputed:
            statusColor = redInvalidTextColor
        case .accepted:
            if order.shipment != nil {
                statusText = R.string.localizable.orderStateShipped()
                statusColor = blueTextColor
            }
        case .completed:
            statusColor = blueTextColor
        case .canceled:
            statusColor = redInvalidTextColor
        case .expired:
            statusColor = redInvalidTextColor
        case .shipped:
            statusColor = blueTextColor
        case .delivered:
            statusColor = blueTextColor
        case .__unknown:
            statusColor = redInvalidTextColor
        }

        return MyIncomeCellData(ID: product.id,
                                status: statusText,
                                statusColorHex: statusColor,
                                price: price.formattedPrice(includeCurrency: true, showFraction: true),
                                date: date,
                                thumbUrl: product.image.first?.asURL())
    }
}
