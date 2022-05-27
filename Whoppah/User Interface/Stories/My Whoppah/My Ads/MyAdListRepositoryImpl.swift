//
//  MyAdsListRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class MyListRepositoryImpl: MyAdListRepository {
    var items: Observable<Swift.Result<(totalCount: Int, elements: [AdViewModel]), Error>> {
        _items.asObservable()
    }
    
    var _items = PublishSubject<Swift.Result<(totalCount: Int, elements: [AdViewModel]), Error>>()
    var itemList = [AdViewModel]()
    var pager = PagedView(pageSize: 25)
    var totalItemCount: Int = 0

    private var bag = DisposeBag()
    private let state: [GraphQL.ProductState]
    private let auction: [GraphQL.AuctionState]
    
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var apollo: ApolloService

    init(state: [GraphQL.ProductState],
         auction: [GraphQL.AuctionState]) {
        self.state = state
        self.auction = auction
    }

    func load() {
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
        var filters = [GraphQL.ProductFilter]()
        if let uuid = user.current?.merchantId.uuidString {
            filters.append(GraphQL.ProductFilter(key: .merchant, value: uuid))
        }

        if !state.isEmpty {
            let stateText = state.map { $0.rawValue }.joined(separator: ",")
            filters.append(GraphQL.ProductFilter(key: .productState, value: stateText))
        }
        if !auction.isEmpty {
            let auctionStateText = auction.map { $0.rawValue }.joined(separator: ",")
            filters.append(GraphQL.ProductFilter(key: .auctionState, value: auctionStateText))
        }
        let query = GraphQL.ProductsQuery(filters: filters,
                                          pagination: pager.getPagination(),
                                          sort: .created,
                                          order: .desc,
                                          playlist: .hls)
        // Cache isn't smart enough to know when variables in a query have changed
        apollo.fetch(query: query, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let search = result.data?.products else { return }
            self.totalItemCount = search.pagination.count
            
            var ads = [AdViewModel]()
            search.items.forEach { product in
                ads.append(AdViewModel(product: product as WhoppahCore.Product))
            }
            self.applyItems(list: ads)
            
            self.pager.onListFetched(page: search.pagination.page, total: search.pagination.pages, limit: search.pagination.limit)
            
            self._items.onNext(.success((totalCount: self.totalItemCount, elements: ads)))
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

    @discardableResult
    func onAdDeleted(id: UUID) -> Bool {
        removeAd(id)
    }

    func getAd(id: UUID) -> AdViewModel? {
        itemList.first(where: { $0.id == id })
    }

    @discardableResult
    func onAdReposted(id: UUID) -> Bool {
        removeAd(id)
    }

    private func removeAd(_ id: UUID) -> Bool {
        if let index = itemList.firstIndex(where: { $0.id == id }) {
            itemList.remove(at: index)
            _items.onNext(.success((totalCount: totalItemCount, elements: itemList)))
            return true
        }
        return false
    }
}
