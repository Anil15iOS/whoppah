//
//  ThreadMessageRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class ThreadMessageRepositoryImpl: ThreadMessageRepository {
    private let threadId: UUID
    private let bag = DisposeBag()
    var paginator = PagedView(pageSize: 15)
    
    @Injected private var apolloService: ApolloService

    required init(threadId: UUID) {
        self.threadId = threadId
    }

    func load(fetchLatest: Bool) -> Observable<Result<[GraphQL.GetMessagesQuery.Data.Message.Item], Error>> {
        Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }

            var filters = [GraphQL.MessageFilter]()
            filters.append(GraphQL.MessageFilter(key: .thread, value: self.threadId.uuidString))
            var pagination = self.paginator.getPagination()
            // If just refreshing the latest messages we force to the first page
            if fetchLatest {
                pagination.page = 1
            }
            let query = GraphQL.GetMessagesQuery(filters: filters,
                                                 pagination: pagination,
                                                 sort: GraphQL.MessageSort.updated,
                                                 order: GraphQL.Ordering.desc)
            self.apolloService.fetch(query: query,
                                       cache: .fetchIgnoringCacheData)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    if let firstError = result.errors?.first {
                        observer.onNext(.failure(firstError))
                        return
                    }
                    guard let data = result.data else { return }
                    let pagination = data.messages.pagination
                    let chatMessages = data.messages.items
                    // If fetching the latest we don't change the 'next' page back to the first page
                    if !fetchLatest {
                        self.paginator.onListFetched(page: pagination.page, total: pagination.pages, limit: pagination.limit)
                    }
                    observer.onNext(.success(chatMessages))
                }, onError: { error in
                    observer.onNext(.failure(error))
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    func touch() -> Observable<Void> {
        var pagination = paginator.getPagination()
        pagination.page = 1

        return apolloService.apply(mutation: GraphQL.TouchThreadMutation(id: threadId, pagination: pagination))
            .map { _ in () }
    }
}
