//
//  GetPageProductBlockAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Auction.BuyNowPrice: Price {}
extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Auction.MinimumBid: Price {}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Auction: WhoppahCore.AuctionBasic {
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock: ProductBlock {
    public var blockProducts: [WhoppahCore.Product] { products.map { $0 as WhoppahCore.Product } }
    public var titleKey: String { slug.titleKey }
    public var buttonKey: String { slug.buttonKey }
}
