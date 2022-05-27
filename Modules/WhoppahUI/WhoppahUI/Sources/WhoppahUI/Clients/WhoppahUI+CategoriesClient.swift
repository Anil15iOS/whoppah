//
//  WhoppahUI+CategoriesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 03/12/2021.
//

import ComposableArchitecture
import WhoppahModel

public extension WhoppahUI {
    struct CategoriesClient {
        public typealias FetchCategoriesByLevelClosure = (Int) -> Effect<[WhoppahModel.Category], Error>
        public typealias FetchSubcategoriesBySlugClosure = (String?) -> Effect<[WhoppahModel.Category], Error>
        
        var fetchCategoriesByLevel: FetchCategoriesByLevelClosure
        var fetchSubCategoriesBySlug: FetchSubcategoriesBySlugClosure

        public init(fetchCategoriesByLevel: @escaping FetchCategoriesByLevelClosure,
                    fetchSubCategoriesBySlug: @escaping FetchSubcategoriesBySlugClosure)
        {
            self.fetchCategoriesByLevel = fetchCategoriesByLevel
            self.fetchSubCategoriesBySlug = fetchSubCategoriesBySlug
        }
    }
}
