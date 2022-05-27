//
//  Products+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.ProductFilterKey: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.ProductFilterKey {
        switch self {
        case .merchant: return .merchant
        case .label: return .label
        case .artist: return .artist
        case .auctionState: return .auctionState
        case .brand: return .brand
        case .category: return .category
        case .designer: return .designer
        case .isInShowroom: return .isInShowroom
        case .material: return .material
        case .price: return .price
        case .productState: return .productState
        case .slug: return .slug
        case .style: return .style
        case .tag: return .tag
        case .color: return .color
        case .title: return .title
        case .expiryDate: return .expiryDate
        case .unknown: return .__unknown("")
        }
    }
}

extension WhoppahModel.ProductFilter: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.ProductFilter {
        .init(key: self.key.toGraphQLModel,
              value: self.value)
    }
}

extension WhoppahModel.ProductSort: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.ProductSort {
        switch self {
        case .default: return .default
        case .title: return .title
        case .askingPrice: return .askingPrice
        case .created: return .created
        case .updated: return .updated
        case .unknown: return .__unknown("")
        }
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Favorite {
        .init(id: self.id,
              created: Date(),
              collection: nil)
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Auction.BuyNowPrice: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Auction.MinimumBid: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Auction: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Auction {
        .init(id: self.id,
              identifier: "",
              state: self.state.toWhoppahModel,
              product: UUID(),
              buyNowPrice: self.buyNowPrice?.toWhoppahModel,
              minimumBid: self.minimumBid?.toWhoppahModel,
              allowBid: self.allowBid,
              allowBuyNow: self.allowBuyNow,
              bidCount: 0,
              bids: [])
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Image: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Image {
        .init(id: self.id,
              url: self.url,
              type: .default,
              orientation: .landscape,
              width: nil,
              height: nil,
              aspectRatio: nil,
              position: 0,
              backgroundColor: nil)
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Attribute.AsLabel: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Label {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              hex: self.color)
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Attribute {
    var toWhoppahModel: WhoppahModel.AbstractAttribute? {
        self.asLabel?.toWhoppahModel
    }
}

extension GraphQL.ProductsQuery.Data.Product.Item: WhoppahModelConvertable {
    var toWhoppahModel: ProductTileItem {
        .init(id: self.id,
              state: self.state.toWhoppahModel,
              title: self.title,
              slug: self.slug,
              description: self.description,
              favorite: self.favorite?.toWhoppahModel,
              auction: self.auction?.toWhoppahModel,
              image: self.images.first?.toWhoppahModel,
              attributes: self.attributes.compactMap({ $0.toWhoppahModel }))
    }
}
