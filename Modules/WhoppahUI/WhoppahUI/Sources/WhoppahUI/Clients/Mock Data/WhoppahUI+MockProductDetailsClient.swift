//
//  WhoppahUI+MockProductDetailsClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/04/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

public extension WhoppahUI.ProductDetailsClient {
    static let mockClient: Self = .init(fetchProduct: { productId in
            .init(value: WhoppahModel.Product.random).eraseToEffect()
    }, fetchProductBySlug: { slug in
            .init(value: WhoppahModel.Product.random).eraseToEffect()
    }, fetchRelatedItems: { product in
            .init(value: [WhoppahModel.ProductTileItem.random]).eraseToEffect()
    }, fetchReviews: { merchantId in
            .init(value: [WhoppahModel.ProductReview.random])
    }, sendProductMessage: { id, message in
            .init(value: UUID())
    }, createBid: { product, amount, createThread in
            .init(value: .random)
    }, translate: { text, language in
            .init(value: "\(text) translated in \(language)")
    }, reportAbuse: { input in
            .init(value: true)
    })
}
