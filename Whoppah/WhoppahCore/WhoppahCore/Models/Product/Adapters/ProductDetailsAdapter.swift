//
//  GetProductProductDetailsAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Auction.Bid.Amount: WhoppahCore.Price {}
extension GraphQL.ProductQuery.Data.Product.Auction.Bid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.ProductQuery.Data.Product.Auction.HighestBid.Amount: WhoppahCore.Price {}
extension GraphQL.ProductQuery.Data.Product.Auction.HighestBid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.ProductQuery.Data.Product.CustomShippingCost: Price {}
extension GraphQL.ProductQuery.Data.Product.BuyNowPrice: Price {}
extension GraphQL.ProductQuery.Data.Product.Auction.BuyNowPrice: Price {}
extension GraphQL.ProductQuery.Data.Product.Auction.MinimumBid: Price {}
extension GraphQL.ProductQuery.Data.Product.Auction: Auction {
    public var currentHighestBid: WhoppahCore.Bid? { highestBid }
    public var allBids: [WhoppahCore.Bid] { bids.compactMap { $0 } }
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.ProductQuery.Data.Product.MerchantFee: Fee {}

extension GraphQL.ProductQuery.Data.Product: ProductDetails {
    public var ar: LegacyARObject? {
        nil
    }

    public var badge: ProductBadge? {
        let res = attributes.compactMap { $0.asLabel }
        guard let label = res.first else { return nil }
        return ProductBadge(slug: label.slug, backgroundHex: label.color)
    }

    public var materials: [Material] { attributes.compactMap { $0.asMaterial } }

    public var price: WhoppahCore.Price? { buyNowPrice }

    public var originalImages: [WhoppahCore.Image] { fullImages.compactMap { $0 } }

    public var favoriteId: UUID? { favorite?.id }

    public var previewImages: [WhoppahCore.Image] { thumbnails.compactMap { $0 } }

    public var productVideos: [WhoppahCore.Video] { videos.map { $0 } }

    public var shipping: WhoppahCore.ShippingMethod? { shippingMethod }

    public var shippingPrice: WhoppahCore.Price? { shippingCost }
    
    public var fee: Fee? { merchantFee }
    
    public var customShippingPrice: Price? { customShippingCost }

    public var user: MerchantBasic { merchant }

    public var currentAuction: WhoppahCore.Auction? { auction }

    public var categoryList: [CategoryBasic] { categories.map { $0 } }

    public var designers: [Designer] { attributes.compactMap { $0.asDesigner } }

    public var artists: [Artist] { attributes.compactMap { $0.asArtist } }

    public var brands: [BrandAttribute] { attributes.compactMap({ $0.asBrand }) }
    
    public var colors: [Color] { attributes.compactMap { $0.asColor } }

    public var styles: [Style] { attributes.compactMap { $0.asStyle } }

    public var location: WhoppahCore.LegacyAddress? { address }

    public var shareURL: URL? { URL(string: shareLink) }
}
