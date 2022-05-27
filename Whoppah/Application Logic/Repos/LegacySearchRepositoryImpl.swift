//
//  SearchRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 13/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class LegacySearchRepositoryImpl: LegacySearchRepository {

    var items: Observable<Result<(totalCount: Int, elements: [AdViewModel]), Error>> { _items.asObservable() }
    var _items = BehaviorSubject<Result<(totalCount: Int, elements: [AdViewModel]), Error>>(value: .success((totalCount: 0, elements: [])))
    var data: Observable<GraphQL.SearchQuery.Data> { _data.compactMap { $0 }.asObservable() }
    var _data = BehaviorSubject<GraphQL.SearchQuery.Data?>(value: nil)
    var itemList = [AdViewModel]()
    var pager = PagedView(pageSize: 25)

    var suggestionItems: Observable<Result<[String], Error>> { _suggestionItems.asObservable() }
    var _suggestionItems = BehaviorSubject<Result<[String], Error>>(value: .success([]))

    var suggestionData: Observable<GraphQL.QuerrySuggestionsQuery.Data> { _suggestionData.compactMap { $0 }.asObservable() }
    var _suggestionData = BehaviorSubject<GraphQL.QuerrySuggestionsQuery.Data?>(value: nil)
 
    private var query: String?
    private var filter: GraphQL.SearchFilterInput?
    private var sort: GraphQL.SearchSort?
    private var ordering: GraphQL.Ordering?
    private var bag = DisposeBag()
    
    @Injected private var apollo: ApolloService

    func load(query _: String?, filter _: GraphQL.SearchFilterInput?) -> Observable<GraphQL.SearchQuery.Data?> {
        apollo.fetch(query: GraphQL.SearchQuery()).flatMapLatest { (result) -> Observable<GraphQL.SearchQuery.Data?> in
            Observable.just(result.data)
        }
    }

    func load(query: String?, filter: GraphQL.SearchFilterInput?, sort: GraphQL.SearchSort?, ordering: GraphQL.Ordering?) {
        bag = DisposeBag()
        pager.resetToFirstPage()
        self.query = query
        self.filter = filter
        self.sort = sort
        self.ordering = ordering
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
        let query = GraphQL.SearchQuery(type: .product,
                                        query: self.query,
                                        filter: filter,
                                        pagination: pager.getPagination(),
                                        sort: sort,
                                        order: ordering,
                                        playlist: .hls)
        apollo.fetch(query: query, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let search = result.data?.search else { return }
            let pagination = search.pagination
            self.pager.onListFetched(page: pagination.page, total: pagination.pages, limit: pagination.limit)
            var ads = [AdViewModel]()
            search.items.forEach { result in
                if let product = result.asProduct {
                    ads.append(AdViewModel(product: product as WhoppahCore.Product))
                }
            }

            self._data.onNext(result.data)
            self._items.onNext(.success((totalCount: search.pagination.count, elements: ads)))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self._items.onNext(.failure(error))
        }).disposed(by: bag)
    }

    func loadSuggestions(query: String?) {
    
        guard let query = query, !query.isEmpty else {
            self._suggestionData.onNext(nil)
            self._suggestionItems.onNext(.success([]))
            return
        }
        
        let queryRequest = GraphQL.QuerrySuggestionsQuery(query: query)
        
        apollo.fetch(query: queryRequest, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let suggestions = result.data?.querySuggestions else { return }
            
            self._suggestionData.onNext(result.data)
            self._suggestionItems.onNext(.success(suggestions))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self._suggestionItems.onNext(.failure(error))
        }).disposed(by: bag)
    }
    
    func getViewModel(atIndex index: Int) -> AdViewModel? {
        guard index < itemList.count else { return nil }
        return itemList[index]
    }

    func numitems() -> Int { itemList.count }

    func applyItems(list: [AdViewModel]) {
        itemList.append(contentsOf: list)
    }
}
