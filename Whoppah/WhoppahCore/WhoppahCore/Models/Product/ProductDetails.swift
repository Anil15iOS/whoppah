//
//  ProductDetails.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol ProductDetails {
    var id: UUID { get }
    var state: GraphQL.ProductState { get }
    var title: String { get }
    var description: String? { get }
    var badge: ProductBadge? { get }
    var condition: GraphQL.ProductCondition { get }
    var quality: GraphQL.ProductQuality { get }
    var width: Int? { get }
    var height: Int? { get }
    var depth: Int? { get }

    // Meta
    var shareURL: URL? { get }
    var isFavorite: Bool { get }
    var favoriteId: UUID? { get }
    var favoriteCount: Int { get }
    var viewCount: Int { get }

    // Selling
    var currentAuction: Auction? { get }
    var price: Price? { get }
    var shippingPrice: Price? { get }
    var fee: Fee? { get }

    // Media
    var ar: LegacyARObject? { get }
    var originalImages: [Image] { get }
    var previewImages: [Image] { get }
    var productVideos: [Video] { get }

    // Merchant
    var user: MerchantBasic { get }

    // Delivery + location
    var deliveryMethod: GraphQL.DeliveryMethod { get }
    var shipping: ShippingMethod? { get }
    var customShippingPrice: Price? { get }
    var location: LegacyAddress? { get }

    // Attributes
    var categoryList: [CategoryBasic] { get }
    var designers: [Designer] { get }
    var artists: [Artist] { get }
    var brands: [BrandAttribute] { get }
    var materials: [Material] { get }
    var colors: [Color] { get }
    var styles: [Style] { get }
    var brandSuggestion: String? { get }
}

extension ProductDetails {
    var supportsAR: Bool { false }
    public var isFavorite: Bool { favoriteId != nil }
}
