//
//  OrderQueryAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 24/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

// auction
extension GraphQL.OrdersQuery.Data.Order.Item.Product.Auction.BuyNowPrice: Price {}
extension GraphQL.OrdersQuery.Data.Order.Item.Product.Auction.MinimumBid: Price {}
extension GraphQL.OrdersQuery.Data.Order.Item.Product.Auction: AuctionBasic {
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.OrdersQuery.Data.Order.Item.Product.Image: Image {}
extension GraphQL.OrdersQuery.Data.Order.Item.Product.Video: Video {}

extension GraphQL.OrdersQuery.Data.Order.Item.Product: Product {
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
                favorite = GraphQL.OrdersQuery.Data.Order.Item.Product.Favorite(id: id)
            } else {
                favorite = nil
            }
        }
    }

    public var ar: LegacyARObject? { arobjects.first }
    public var price: WhoppahCore.Price? { currentAuction?.buyNowValue }
    public var currentAuction: WhoppahCore.AuctionBasic? { auction }
}
