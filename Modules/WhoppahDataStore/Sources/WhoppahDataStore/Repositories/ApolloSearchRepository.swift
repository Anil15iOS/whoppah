//
//  ApolloSearchRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 17/03/2022.
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Resolver
import Apollo
import Combine
import WhoppahCoreNext

struct ApolloSearchRepository: SearchRepository {
    @Injected private var apollo: ApolloService
    
    func search(input: SearchProductsInput) -> AnyPublisher<ProductSearchResultsSet, Error> {
        let facets = input.facets?.map({ searchKey in
            searchKey.toGraphQLModel
        })
        let filters = input.filters?.map({ filterInput in
            filterInput.toGraphQLModel
        })
        let query = GraphQL.SearchProductsQuery(query: input.query,
                                                pagination: input.pagination?.toGraphQLModel ?? WhoppahModel.Pagination().toGraphQLModel,
                                                sort: input.sort?.toGraphQLModel ?? .default,
                                                order: input.order?.toGraphQLModel ?? .desc,
                                                facets: facets ?? [],
                                                filters: filters ?? [])
        return apollo.fetch(query: query,
                            cache: .fetchIgnoringCacheData)
        
        .tryMap { result in
            guard let items = result.data?.searchProducts?.items,
                  let pagination = result.data?.searchProducts?.pagination?.toWhoppahModel,
                  let facets = result.data?.searchProducts?.facets
            else {
                throw WhoppahRepository.Error.noData
            }
            
            let searchItems = items.compactMap { $0?.toWhoppahModel }
            let searchFacets = facets.compactMap { $0?.toWhoppahModel }
            
            return ProductSearchResultsSet(items: searchItems,
                                           pagination: pagination,
                                           facets: searchFacets)
        }
        .eraseToAnyPublisher()
    }
    
    func saveSearch(input: SearchProductsInput) -> AnyPublisher<Bool, Error> {
        // TODO: Replace this when the mutation is available on the backend.
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
