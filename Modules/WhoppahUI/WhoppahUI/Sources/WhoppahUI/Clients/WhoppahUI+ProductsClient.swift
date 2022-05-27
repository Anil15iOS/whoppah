//
//  WhoppahUI+ProductsClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

public extension WhoppahUI {
    struct ProductsClient {
        public typealias FetchProductsClosure = ([ProductFilter], Pagination, ProductSort, Ordering) -> Effect<[ProductTileItem], Error>
        
        var fetchProducts: FetchProductsClosure
        
        public init(fetchProducts: @escaping FetchProductsClosure) {
            self.fetchProducts = fetchProducts
        }
    }
}
