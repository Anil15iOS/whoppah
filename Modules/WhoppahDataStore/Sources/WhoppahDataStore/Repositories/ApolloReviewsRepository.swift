//
//  ApolloReviewsRepository.swift
//  WhoppahDataStore
//
//  Created by Marko Stojkovic on 4.5.22..
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Resolver
import Combine

public struct ApolloReviewsRepository: ReviewsRepository {
    @Injected private var apollo: ApolloService
    
    public func fetchReviews(merchantId: UUID) -> AnyPublisher<[ProductReview], Error> {
        let query = GraphQL.GetReviewsQuery(filters: [.init(key: .merchant,
                                                            value: merchantId.uuidString)],
                                               pagination: nil,
                                               sort: nil,
                                               order: nil)
        
        return apollo.fetch(query: query)
            .tryMap { result in
                guard let reviewItems = result.data?.reviews.items else {
                    throw WhoppahRepository.Error.noData
                }
                
                return reviewItems.compactMap { $0.toWhoppahModel }
            }
            .eraseToAnyPublisher()
    }
}
