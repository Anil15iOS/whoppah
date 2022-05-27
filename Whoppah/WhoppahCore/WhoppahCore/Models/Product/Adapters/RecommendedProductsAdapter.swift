//
//  RecommendedProductsAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Auction.BuyNowPrice: Price {}
extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Auction.MinimumBid: Price {}
extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Auction: AuctionBasic {
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Image: Image {}
extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Video: Video {}

extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct: Product {
    public var image: [WhoppahCore.Image] { images.map { $0 } }
    public var video: [WhoppahCore.Video] { videos.map { $0 } }

    public var badge: ProductBadge? {
        let res = attributes.compactMap { $0.asLabel }
        guard let label = res.first else { return nil }
        return ProductBadge(slug: label.slug, backgroundHex: label.color)
    }

    public var favoriteId: UUID? {
        get {
            favorite?.id
        }
        set {
            if let id = newValue {
                favorite = GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Favorite(id: id)
            } else {
                favorite = nil
            }
        }
    }

    public var ar: LegacyARObject? { arobjects.first }
    public var price: WhoppahCore.Price? { currentAuction?.buyNowValue }
    public var currentAuction: WhoppahCore.AuctionBasic? { auction }
}
