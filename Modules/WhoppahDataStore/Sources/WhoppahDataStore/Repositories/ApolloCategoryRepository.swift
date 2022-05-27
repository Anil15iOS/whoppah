//
//  ApolloCategoryRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 26/11/2021.
//

import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel

class ApolloCategoryRepository: CategoryRepository {
    @Injected private var apollo: ApolloService
    
    func loadCategories(atLevel level: Int) -> AnyPublisher<[WhoppahModel.Category], Error>
    {
        var filters = [GraphQL.CategoryFilter]()
        let category = GraphQL.CategoryFilter(key: .level, value: String(level))
        filters.append(category)
        let query = GraphQL.GetCategoriesQuery(filters: filters)
        
        return apollo.fetch(query: query,
                            cache: .returnCacheDataAndFetch)
        .tryMap { result -> [WhoppahModel.Category] in
            guard let apolloCategories = result.data?.categories.items else {
                throw WhoppahRepository.Error.noData
            }
            return apolloCategories.map { $0.toWhoppahModel }
        }
        .eraseToAnyPublisher()
    }
    
    func subcategories(categorySlug: String?,
                       style: String?,
                       brand: String?) -> AnyPublisher<[WhoppahModel.Category], Error>
    {
        let query = GraphQL.GetSubcategoriesQuery(category: categorySlug, style: style, brand: brand)
        return apollo.fetch(query: query,
                            cache: .returnCacheDataAndFetch)
            .tryMap { result -> [WhoppahModel.Category] in
                guard let categories = result.data?.subcategories else {
                    throw WhoppahRepository.Error.noData
                }
                return categories.map { $0.toWhoppahModel }
            }
            .eraseToAnyPublisher()
        
    }
}
