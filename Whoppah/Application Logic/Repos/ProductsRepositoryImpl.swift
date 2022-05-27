//
//  ProductsRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 12/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class ProductsRepositoryImpl: LegacyProductsRepository {
    
    @Injected private var apolloService: ApolloService
    
    var data: Observable<GraphQL.ProductsQuery.Data> {
        _data.compactMap { $0 }.asObservable()
    }

    var _data = BehaviorSubject<GraphQL.ProductsQuery.Data?>(value: nil)
    var items: Observable<Result<(totalCount: Int, elements: [AdViewModel]), Error>> {
        _items.asObservable()
    }

    var _items = BehaviorSubject<Result<(totalCount: Int, elements: [AdViewModel]), Error>>(value: .success((totalCount: 0, elements: [])))
    var itemList = [AdViewModel]()
    var pager = PagedView(pageSize: 25)
    private var id: UUID?
    private var auctionState: GraphQL.AuctionState?
    private var productState: GraphQL.ProductState?

    private var bag = DisposeBag()

    func load(id: UUID, auctionState: GraphQL.AuctionState?, productState: GraphQL.ProductState?) {
        bag = DisposeBag()
        pager.resetToFirstPage()
        itemList.removeAll()
        self.id = id
        self.auctionState = auctionState
        self.productState = productState
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
        var filters = [GraphQL.ProductFilter]()
        filters.append(GraphQL.ProductFilter(key: .merchant, value: id!.uuidString))
        if let state = productState {
            filters.append(GraphQL.ProductFilter(key: .productState, value: state.rawValue))
        }
        if let auctionState = self.auctionState {
            filters.append(GraphQL.ProductFilter(key: .auctionState, value: auctionState.rawValue))
        }
        let query = GraphQL.ProductsQuery(filters: filters,
                                          pagination: pager.getPagination(), sort: .default, order: .desc, playlist: .hls)
        // Cache isn't smart enough to know when variables in a query have changed
        apolloService.fetch(query: query, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let data = result.data else { return }
            let search = data.products
            self.pager.onListFetched(page: search.pagination.page, total: search.pagination.pages, limit: search.pagination.limit)
            var ads = [AdViewModel]()
            search.items.forEach { product in
                ads.append(AdViewModel(product: product as WhoppahCore.Product))
            }

            self._data.onNext(data)
            self._items.onNext(.success((totalCount: search.pagination.count, elements: ads)))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self._items.onNext(.failure(error))
        }).disposed(by: bag)
    }

    func getViewModel(atIndex index: Int) -> AdViewModel? {
        guard index < itemList.count else { return nil }
        return itemList[index]
    }

    func numitems() -> Int {
        itemList.count
    }

    func applyItems(list: [AdViewModel]) {
        itemList.append(contentsOf: list)
    }
}
