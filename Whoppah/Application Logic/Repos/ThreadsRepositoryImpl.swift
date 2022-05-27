//
//  ThreadAndNotificationsRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 27/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class ThreadsRepositoryImpl: ThreadsRepository {
    @Injected private var apolloService: ApolloService
    
    var threads: Driver<Result<[ThreadOverviewCellViewModel], Error>> {
        _threads.asDriver(onErrorJustReturn: .success([]))
    }

    var _threads = BehaviorSubject<Result<[ThreadOverviewCellViewModel], Error>>(value: .success([]))
    var threadList = [ThreadOverviewCellViewModel]()
    var pager = PagedView(pageSize: 15)

    let messageDefaultPagination: GraphQL.Pagination
    private var bag = DisposeBag()

    init() {
        messageDefaultPagination = GraphQL.Pagination(page: 1, limit: 15)
    }

    func load() {
        bag = DisposeBag()
        pager.resetToFirstPage()
        threadList.removeAll()
        loadThreads()
    }

    func loadMore() -> Bool {
        guard pager.hasMorePages() else {
            return false
        }

        loadThreads()
        return true
    }

    private func loadThreads() {
        let query = GraphQL.GetThreadsQuery(filters: [],
                                            pagination: pager.getPagination(),
                                            messagePagination: messageDefaultPagination,
                                            sort: .updated,
                                            order: .desc)
        apolloService.fetch(query: query, cache: .fetchIgnoringCacheData).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let data = result.data else { return }
            let search = data.threads
            self.pager.onListFetched(page: search.pagination.page, total: search.pagination.pages, limit: search.pagination.limit)
            var ads = [ThreadOverviewCellViewModel]()
            search.items.forEach { thread in
                ads.append(ThreadOverviewCellViewModel(thread: thread))
            }

            self._threads.onNext(.success(ads))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self._threads.onNext(.failure(error))
        }).disposed(by: bag)
    }

    func getViewModel(atIndex index: Int) -> ThreadOverviewCellViewModel? {
        guard index < threadList.count else { return nil }
        return threadList[index]
    }

    func numitems() -> Int {
        threadList.count
    }

    func applyItems(list: [ThreadOverviewCellViewModel]) {
        threadList.append(contentsOf: list)
    }

    func clear() {
        threadList.removeAll()
        _threads.onNext(.success([]))
    }
}
