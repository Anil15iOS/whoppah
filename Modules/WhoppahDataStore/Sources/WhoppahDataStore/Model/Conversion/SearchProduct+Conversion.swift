//
//  SearchProduct+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 18/03/2022.
//

import Foundation
import WhoppahModel

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item: WhoppahModelConvertable {
    var toWhoppahModel: ProductTileItem {
        let attributes: [AbstractAttribute]? = self.attributes.compactMap { $0.toWhoppahModel }
        
        return .init(
            id: self.id,
            state: self.state.toWhoppahModel,
            title: self.title,
            slug: self.slug,
            description: self.description,
            favorite: self.favorite?.toWhoppahModel,
            auction: self.auction?.toWhoppahModel,
            image: self.image?.toWhoppahModel,
            attributes: attributes)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Attribute: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.AbstractAttribute? {
        self.asLabel?.toWhoppahModel
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Attribute.AsLabel: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Label {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              hex: self.hex)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: Favorite {
        .init(id: self.id,
              created: self.created.toWhoppahModel)
    }
}

extension GraphQL.CreateFavoriteMutation.Data.CreateFavorite.Item.AsProduct.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: Favorite {
        .init(id: self.id, created: Date())
    }
}

extension GraphQL.SearchFacetKey: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.SearchFacetKey {
        switch self {
        case .category:         return .category
        case .quality:          return .quality
        case .label:            return .label
        case .artOrientation:   return .artOrientation
        case .artSize:          return .artSize
        case .artSubject:       return .artSubject
        case .brand:            return .brand
        case .country:          return .country
        case .material:         return .material
        case .style:            return .style
        case .color:            return .color
        case .__unknown:        return .unknown
        }
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Facet: WhoppahModelConvertable {
    var toWhoppahModel: SearchFacet {
        let facetValues = self.values?.compactMap({ $0?.toWhoppahModel })
        return .init(key: self.key?.toWhoppahModel,
                     values: facetValues)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Facet.Value: WhoppahModelConvertable {
    var toWhoppahModel: SearchFacetValue {
        .init(value: self.value,
              count: self.count,
              category: self.category?.id,
              merchant: nil)
    }
}

extension FavoriteInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.FavoriteInput {
        .init(contentType: self.contentType.toGraphQLModel,
              objectId: self.objectId,
              collection: self.collection)
    }
}

extension ContentType: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.ContentType {
        switch self {
        case .product:      return .product
        case .message:      return .message
        case .merchant:     return .merchant
        case .unknown:      return .__unknown("")
        }
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Auction: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Auction {
        .init(id: self.id,
              identifier: self.identifier,
              state: self.state.toWhoppahModel,
              product: self.product.id,
              buyNowPrice: self.buyNowPrice?.toWhoppahModel,
              minimumBid: self.minimumBid?.toWhoppahModel,
              allowBid: self.allowBid,
              allowBuyNow: self.allowBuyNow,
              bidCount: 0,
              bids: [])
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Auction.BuyNowPrice: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Auction.MinimumBid: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Item.Image: WhoppahModelConvertable {
    var toWhoppahModel: Image {
        .init(id: self.id,
              url: self.url,
              type: self.type.toWhoppahModel,
              position: self.position)
    }
}

extension Pagination: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.Pagination {
        .init(page: self.page, limit: self.limit)
    }
}

extension GraphQL.SearchProductsQuery.Data.SearchProduct.Pagination: WhoppahModelConvertable {
    var toWhoppahModel: ProductSearchResultsSet.Pagination {
        .init(page: self.page, pages: self.pages, count: self.count)
    }
}

extension SearchSort: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.SearchSort {
        switch self {
        case .default:      return .default
        case .title:        return .title
        case .created:      return .created
        case .distance:     return .distance
        case .popularity:   return .popularity
        case .price:        return .price
        case .unknown:      return .__unknown("")
        }
    }
}

extension Ordering: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.Ordering {
        switch self {
        case .asc:          return .asc
        case .desc:         return .desc
        case .rand:         return .rand
        case .unknown:      return .__unknown("")
        }
    }
}

extension SearchFilterKey: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.SearchFilterKey {
        switch self {
        case .price:            return .price
        case .label:            return .label
        case .brand:            return .brand
        case .category:         return .category
        case .country:          return .country
        case .material:         return .material
        case .style:            return .style
        case .color:            return .color
        case .artSize:          return .artSize
        case .artSubject:       return .artSubject
        case .artOrientation:   return .artOrientation
        case .width:            return .width
        case .height:           return .height
        case .depth:            return .depth
        case .seatHeight:       return .seatHeight
        case .numberOfItems:    return .numberOfItems
        case .inShowroom:       return .inShowroom
        case .quality:          return .quality
        case .allowBid:         return .allowBid
        case .availability:     return .availability
        case .unknown:          return .__unknown("")
        }
    }
}

extension SearchFacetKey: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.SearchFacetKey {
        switch self {
        case .category:         return .category
        case .brand:            return .brand
        case .style:            return .style
        case .material:         return .material
        case .color:            return .color
        case .country:          return .country
        case .artSize:          return .artSize
        case .artSubject:       return .artSubject
        case .artOrientation:   return .artOrientation
        case .label:            return .label
        case .quality:          return .quality
        case .unknown:          return .__unknown("")
        }
    }
}

extension FilterInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.FilterInput {
        .init(key: self.key?.toGraphQLModel, value: self.value)
    }
}
