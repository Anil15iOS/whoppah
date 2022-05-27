//
//  Product.swift
//  WhoppahCore
//
//  Created by Eddie Long on 09/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public struct ProductBadge {
    public var textKey: String {
        "label-\(slug)"
    }

    public var colorKey: String {
        "label-\(slug)-color"
    }

    public let slug: String
    public let backgroundHex: String?

    public init(slug: String, backgroundHex: String?) {
        self.slug = slug
        self.backgroundHex = backgroundHex
    }
}

public protocol Product {
    var id: UUID { get }
    var state: GraphQL.ProductState { get }
    var image: [Image] { get }
    var video: [Video] { get }
    var title: String { get }
    var price: Price? { get }
    var ar: LegacyARObject? { get }
    var favoriteId: UUID? { get set }
    var isFavorite: Bool { get }
    var badge: ProductBadge? { get }
    var currentAuction: AuctionBasic? { get }
    var width: Int? { get }
    var height: Int? { get }
}

extension Product {
    public var isFavorite: Bool { favoriteId != nil }
}
