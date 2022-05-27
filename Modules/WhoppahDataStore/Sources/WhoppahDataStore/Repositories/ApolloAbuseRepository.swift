//
//  ApolloAbuseRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 04/05/2022.
//

import Apollo
import Combine
import Resolver
import WhoppahModel
import WhoppahRepository

struct ApolloAbuseRepository: AbuseRepository {
    @Injected private var apollo: ApolloService
    
    func reportAbuse(_ input: AbuseReportInput) -> AnyPublisher<Bool, Error> {
        let mutation = GraphQL.CreateAbuseReportMutation(input: input.toGraphQLModel)
        return apollo.apply(mutation: mutation)
            .tryMap { result -> Bool in
                guard let success = result.data?.createAbuseReport else {
                    throw WhoppahRepository.Error.noData
                }
                return success
            }
            .eraseToAnyPublisher()
    }
}
