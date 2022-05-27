//
//  ApolloBidRepository.swift
//  WhoppahDataStore
//
//  Created by Marko Stojkovic on 12.4.22..
//

import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel
import Foundation

class ApolloBidRepository: BidRepository {
    
    @Injected private var apollo: ApolloService

    func get(withId id: UUID) -> AnyPublisher<Bid, Error> {
        let query = GraphQL.GetBidQuery(id: id)
        
       return apollo.fetch(query: query)
            .tryMap { result in
                guard let bid = result.data?.bid
                else {
                    throw WhoppahRepository.Error.noData
                }
                return bid.toWhoppahModel
            }
            .eraseToAnyPublisher()
    }
}
