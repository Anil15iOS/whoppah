//
//  UserRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class UserRepositoryImpl: LegacyUserRepository {
    @LazyInjected private var apollo: ApolloService
    
    private var userWatcher: GraphQLQueryWatcher<GraphQL.GetMeQuery>?
    var current: Observable<LegacyMember?> {
        _current.asObservable()
    }

    private var _current = BehaviorSubject<LegacyMember?>(value: nil)

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedOut), name: InAppNotifier.NotificationName.userLoggedOut.name, object: nil)
    }

    func loadCurrentUser() {
        if let watcher = userWatcher {
            watcher.refetch()
        } else {
            userWatcher = apollo.watch(query: GraphQL.GetMeQuery()) { [weak self] result in
                switch result {
                case let .success(user):
                    if let me = user.me {
                        self?._current.onNext(me)
                    } else {
                        self?._current.onError(MemberErrors.unableToFetchMember)
                    }
                case let .failure(error):
                    self?._current.onError(error)
                }
            }
        }
    }

    @objc func userLoggedOut() {
        userWatcher = nil
        _current.onNext(nil)
        apollo.updateCache(query: GraphQL.GetMeQuery()) { (cachedQuery: inout GraphQL.GetMeQuery.Data) in
            cachedQuery.me = nil
        }
    }
}
