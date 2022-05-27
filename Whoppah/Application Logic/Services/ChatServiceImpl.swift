//
//  ChatService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/18/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class ChatServiceImpl: ChatService {
    var unread: Driver<Int> {
        _unread.asDriver(onErrorJustReturn: 0)
    }

    private let _unread = BehaviorRelay<Int>(value: 0)
    private let bag = DisposeBag()
    
    @Injected private var apollo: ApolloService
    
    init() {}
    
    func sendChatMessage(id: UUID, text: String) -> Observable<GraphQL.SendMessageMutation.Data.SendMessage> {
        apollo.apply(mutation: GraphQL.SendMessageMutation(id: id, body: text)).compactMap { $0.data?.sendMessage }
    }

    func getChatThread(filter: ThreadFilterKey, id: UUID) -> Observable<UUID?> {
        var filters = [GraphQL.ThreadFilter]()
        switch filter {
        case .item:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.item, value: id.uuidString))
        case .thread:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.thread, value: id.uuidString))
        }
        let query = GraphQL.GetThreadsQuery(filters: filters)
        return apollo.fetch(query: query).map {
            $0.data?.threads.items.first?.id
        }
    }

    func sendProductMessage(id: UUID, body: String) -> Observable<UUID?> {
        let mutation = GraphQL.AskProductQuestionMutation(id: id, body: body)
        return apollo.apply(mutation: mutation).map { $0.data?.askProductQuestion.id }
    }

    // MARK: -

    func updateUnreadCount() {
        let query = GraphQL.GetUnreadMessageCountQuery()
        apollo.fetch(query: query, cache: .fetchIgnoringCacheData)
            .compactMap { $0.data?.getUnreadMessageCount }
            .subscribe(onNext: { [weak self] count in
                self?._unread.accept(count)
            }).disposed(by: bag)
    }
}
