//
//  WhoppahUI+MockProductsClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

extension WhoppahUI.ProductsClient {
    static let mockClient: Self = .init { _, _, _, _ in
        var results = [WhoppahModel.ProductTileItem]()
        
        for _ in 0...30 {
            results.append(WhoppahModel.ProductTileItem.random)
        }
        
        return .init(value: results).eraseToEffect()
    }
}
