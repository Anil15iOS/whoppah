//
//  RelatedProduct+Conversion.swift
//  
//
//  Created by Marko Stojkovic on 20.4.22..
//

import Foundation
import WhoppahModel

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.ShippingCost: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Merchant: WhoppahModelConvertable {
    var toWhoppahModel: Merchant {
        return .init(id: self.id,
                     type: self.type.toWhoppahModel,
                     name: self.name,
                     slug: "",
                     created: self.created.toWhoppahModel,
                     currency: .unknown,
                     addresses: [],
                     members: [],
                     images: [],
                     videos: [],
                     favorites: [],
                     favoritecollections: [])
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.FullImage: WhoppahModelConvertable {
    var toWhoppahModel: Image {
        return .init(id: self.id,
                     url: self.url,
                     type: .unknown,
                     position: 0)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Arobject: WhoppahModelConvertable {
    var toWhoppahModel: ARObject {
        return .init(id: self.id,
                     url: self.url,
                     platform: self.platform.toWhoppahModel)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Category: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        return .init(id: self.id,
                     title: self.title,
                     slug: self.slug,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Favorite {
        .init(id: self.id,
              created: Date(),
              collection: nil)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Thumbnail: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Image {
        return .init(id: self.id,
                     url: self.url,
                     type: .unknown,
                     position: 0)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction.BuyNowPrice: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction.MinimumBid: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Auction {
        .init(id: self.id,
              identifier: "",
              state: self.state.toWhoppahModel,
              product: UUID(),
              buyNowPrice: self.buyNowPrice?.toWhoppahModel,
              minimumBid: self.minimumBid?.toWhoppahModel,
              allowBid: self.allowBid,
              allowBuyNow: self.allowBuyNow,
              bidCount: self.bidCount,
              bids: [])
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Attribute.AsLabel: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Label {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              hex: self.color)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Attribute {
    var toWhoppahModel: WhoppahModel.AbstractAttribute? {
        self.asLabel?.toWhoppahModel
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct: WhoppahModelConvertable {
    var toWhoppahModel: ProductTileItem {
        let attributes: [AbstractAttribute]? = self.attributes.compactMap { $0.toWhoppahModel }
        
        return .init(id: self.id,
                     state: self.state.toWhoppahModel,
                     title: self.title,
                     slug: self.slug,
                     description: self.description,
                     favorite: self.favorite?.toWhoppahModel,
                     auction: self.auction?.toWhoppahModel,
                     image: self.thumbnails.first?.toWhoppahModel,
                     attributes: attributes)
    }
}
