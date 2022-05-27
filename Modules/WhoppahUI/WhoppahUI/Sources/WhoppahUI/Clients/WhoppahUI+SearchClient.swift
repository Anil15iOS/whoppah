//
//  WhoppahUI+SearchClient.swift.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 22/03/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

public extension WhoppahUI {
    struct SearchClient {
        public typealias SearchClosure = (SearchProductsInput) -> Effect<ProductSearchResultsSet, Error>
        public typealias SaveSearchClosure = (SearchProductsInput) -> Effect<Bool, Error>
        
        var search: SearchClosure
        var saveSearch: SaveSearchClosure
        
        public init(search: @escaping SearchClosure,
                    saveSearch: @escaping SaveSearchClosure)
        {
            self.search = search
            self.saveSearch = saveSearch
        }
    }
}
