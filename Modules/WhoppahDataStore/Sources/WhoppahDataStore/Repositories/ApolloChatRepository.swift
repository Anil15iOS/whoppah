//
//  ApolloChatRepository.swift
//  
//
//  Created by Marko Stojkovic on 21.4.22..
//

import Foundation
import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel

class ApolloChatRepository: ChatRepository {
    
    @Injected private var apollo: ApolloService
    
    init() {}
    
    func sendProductMessage(id: UUID,
                            body: String) -> AnyPublisher<UUID?, Error> {
        let mutation = GraphQL.AskProductQuestionMutation(id: id,
                                                          body: body)
        return apollo.apply(mutation: mutation)
            .tryMap({ result -> UUID in
                guard let id = result.data?.askProductQuestion.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            })
            .eraseToAnyPublisher()
    }
    
    func getChatThread(filter: ThreadFilterKey,
                       id: UUID) -> AnyPublisher<UUID?, Error> {
        var filters = [GraphQL.ThreadFilter]()
        switch filter {
        case .item:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.item,
                                                value: id.uuidString))
        case .thread:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.thread,
                                                value: id.uuidString))
        case .startedBy:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.startedBy,
                                                value: id.uuidString))
        case .unknown:
            filters.append(GraphQL.ThreadFilter(key: GraphQL.ThreadFilterKey.__unknown(""),
                                                value: id.uuidString))
        }
        let query = GraphQL.GetThreadsQuery(filters: filters)
        
        return apollo.fetch(query: query)
            .tryMap { result -> UUID in
                guard let id = result.data?.threads.items.first?.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            }
            .eraseToAnyPublisher()
    }
}
