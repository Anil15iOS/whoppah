//
//  ProductDetailView+Model+Update.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/04/2022.
//

import Foundation
import WhoppahModel

public extension ProductDetailView.Model {
    mutating func update(from product: Product) {
        self.product = product
    }
    
    mutating func updateRelatedProducts(_ products: [ProductTileItem]) {
        self.relatedProducts.newProductItems = products
    }
}
