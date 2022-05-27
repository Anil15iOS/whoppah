//
//  ApolloShippingMethodsRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 01/05/2022.
//

import Apollo
import Foundation
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel

struct ApolloShippingMethodsRepository: ShippingMethodsRepository {
    
    @Injected private var apollo: ApolloService
    
    func shippingMethods(from originCountry: Country?, to destinationCountry: Country?) -> AnyPublisher<[ShippingMethod], Error> {
        let originString = originCountry?.rawValue.uppercased()
        let destinationString = destinationCountry?.rawValue.uppercased()
        let query = GraphQL.GetShippingMethodsQuery(origin: originString, destination: destinationString)
        
        return apollo.fetch(query: query)
            .tryMap { result in
                guard let shippingMethods = result.data?.shippingMethods else {
                    throw WhoppahRepository.Error.noData
                }
                return shippingMethods.compactMap { $0.toWhoppahModel }
            }
            .eraseToAnyPublisher()
    }
}
