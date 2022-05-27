//
//  OrderRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 09/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

final class OrderRepositoryImpl: OrderRepository {
    var items: Observable<Result<[GraphQL.OrdersQuery.Data.Order.Item], Error>> {
        _items.asObservable()
    }

    var _items = BehaviorSubject<Result<[GraphQL.OrdersQuery.Data.Order.Item], Error>>(value: .success([]))
    var itemList = [GraphQL.OrdersQuery.Data.Order.Item]()
    var pager = PagedView(pageSize: 25)
    private var id: UUID?
    private let state: [GraphQL.OrderState]

    private var bag = DisposeBag()
    
    @Injected private var apollo: ApolloService

    required init(state: [GraphQL.OrderState]) {
        self.state = state
    }

    func load(merchantId: UUID) {
        id = merchantId
        bag = DisposeBag()
        pager.resetToFirstPage()
        itemList.removeAll()
        loadItems()
    }

    func loadMore() -> Bool {
        guard pager.hasMorePages() else {
            return false
        }

        loadItems()
        return true
    }

    private func loadItems() {
        var filters = [GraphQL.OrderFilter]()
        for state in state {
            filters.append(GraphQL.OrderFilter(key: .state, value: state.rawValue))
        }
        if let id = id {
            filters.append(GraphQL.OrderFilter(key: .merchant, value: id.uuidString))
        }
        let query = GraphQL.OrdersQuery(filters: filters,
                                        pagination: pager.getPagination(), sort: .created, order: .desc, playlist: .hls)
        // Cache isn't smart enough to know when variables in a query have changed
        apollo.fetch(query: query, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let data = result.data else { return }
            let search = data.orders
            self.pager.onListFetched(page: search.pagination.page, total: search.pagination.pages, limit: search.pagination.limit)
            var ads = [GraphQL.OrdersQuery.Data.Order.Item]()
            search.items.forEach { product in
                ads.append(product)
            }

            self._items.onNext(.success(ads))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self._items.onNext(.failure(error))
        }).disposed(by: bag)
    }

    func getViewModel(atIndex index: Int) -> GraphQL.OrdersQuery.Data.Order.Item? {
        guard index < itemList.count else { return nil }
        return itemList[index]
    }

    func numitems() -> Int {
        itemList.count
    }

    func applyItems(list: [GraphQL.OrdersQuery.Data.Order.Item]) {
        itemList.append(contentsOf: list)
    }
}
