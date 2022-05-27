//
//  ApolloProductsRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Resolver
import Apollo
import Combine
import WhoppahCoreNext

struct ApolloProductsRepository: ProductsRepository {
    @Injected private var apollo: ApolloService
    
    func fetchProducts(filters: [ProductFilter],
                       pagination: Pagination,
                       sort: ProductSort,
                       ordering: Ordering) -> AnyPublisher<[ProductTileItem], Error>
    {
        let filters = filters.map { $0.toGraphQLModel }
        let query = GraphQL.ProductsQuery(filters: filters,
                                          pagination: pagination.toGraphQLModel,
                                          sort: sort.toGraphQLModel,
                                          order: ordering.toGraphQLModel,
                                          playlist: nil)
        return apollo.fetch(query: query,
                            cache: .fetchIgnoringCacheData)
            .tryMap { result in
                guard let items = result.data?.products.items else {
                    throw WhoppahRepository.Error.noData
                }
                
                return items.map { $0.toWhoppahModel }
            }
            .eraseToAnyPublisher()
    }
}
