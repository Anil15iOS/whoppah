//
//  FavoritedProduct.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation

public struct FavoritedProduct: Equatable {
    public let productId: UUID
    public let favorite: Favorite
    
    public init(productId: UUID,
                favorite: Favorite)
    {
        self.productId = productId
        self.favorite = favorite
    }
}
