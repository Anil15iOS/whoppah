//
//  ProductFragment.swift
//  WhoppahCore
//
//  Created by Eddie Long on 09/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Image: Image {}
extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Video: Video {}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product: Product {
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
                favorite = GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Favorite(id: id)
            } else {
                favorite = nil
            }
        }
    }

    public var ar: LegacyARObject? { arobjects.first }
    public var price: WhoppahCore.Price? { currentAuction?.buyNowValue }
    public var currentAuction: WhoppahCore.AuctionBasic? { auction }
}
