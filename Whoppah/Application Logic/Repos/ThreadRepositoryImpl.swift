//
//  ThreadRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 01/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

final class ThreadRepositoryImpl: ThreadRepository {
    private var threadWatcher: GraphQLQueryWatcher<GraphQL.GetThreadQuery>?

    @Injected private var apolloService: ApolloService
    
    var thread: Observable<GraphQL.GetThreadQuery.Data.Thread?> {
        _thread.asObservable()
    }

    let _thread = BehaviorSubject<GraphQL.GetThreadQuery.Data.Thread?>(value: nil)

    func fetchThread(id: UUID) {
        if let watcher = threadWatcher {
            watcher.refetch()
        } else {
            threadWatcher = apolloService.watch(query: GraphQL.GetThreadQuery(id: id)) { [weak self] result in
                switch result {
                case let .success(thread):
                    self?._thread.onNext(thread.thread)
                case let .failure(error):
                    self?._thread.onError(error)
                }
            }
        }
    }
}
