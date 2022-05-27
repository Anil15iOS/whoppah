//
//  MerchantFavoriteAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 10/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Auction.BuyNowPrice: Price {}
extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Auction.MinimumBid: Price {}

extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Auction: AuctionBasic {
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Image: Image {}
extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Video: Video {}

extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct: Product {
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
                favorite = GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Favorite(id: id)
            } else {
                favorite = nil
            }
        }
    }

    public var ar: LegacyARObject? { arobjects.first }
    public var price: WhoppahCore.Price? { currentAuction?.buyNowValue }
    public var currentAuction: WhoppahCore.AuctionBasic? { auction }
}
