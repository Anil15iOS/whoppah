//
//  SimilarProduct+Conversion.swift
//  
//
//  Created by Marko Stojkovic on 20.4.22..
//

import Foundation
import WhoppahModel

extension GraphQL.SimilarProductsQuery.Data.SimilarProduct.Image: WhoppahModelConvertable {
    var toWhoppahModel: Image {
        return .init(id: self.id,
                     url: self.url,
                     type: .unknown,
                     position: 0)
    }
}

extension GraphQL.SimilarProductsQuery.Data.SimilarProduct.Video: WhoppahModelConvertable {
    var toWhoppahModel: Video {
        return .init(id: self.id,
                     url: self.url,
                     thumbnail: self.thumbnail,
                     type: .unknown)
    }
}

extension GraphQL.SimilarProductsQuery.Data.SimilarProduct.Arobject: WhoppahModelConvertable {
    var toWhoppahModel: ARObject {
        return .init(id: self.id,
                     url: self.url,
                     platform: self.platform.toWhoppahModel)
    }
}

extension GraphQL.SimilarProductsQuery.Data.SimilarProduct.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Favorite {
        .init(id: self.id,
              created: Date(),
              collection: nil)
    }
}

extension GraphQL.SimilarProductsQuery.Data.SimilarProduct: WhoppahModelConvertable {
    var toWhoppahModel: Product {
        //TODO: Marko - Check for price value, merchant shoud be optional?
        let price = Price(amount: 0, currency: .unknown)
    
        let merchant = Merchant(id: UUID(),
                                type: .unknown,
                                name: "",
                                slug: "",
                                created: Date(),
                                currency: .unknown,
                                addresses: [],
                                members: [],
                                images: [],
                                videos: [],
                                favorites: [],
                                favoritecollections: [])
        
        return .init(id: self.id,
                     identifier: self.__typename,
                     state: self.state.toWhoppahModel,
                     title: self.title,
                     slug: self.slug,
                     link: "",
                     condition: .unknown,
                     quality: .unknown,
                     deliveryMethod: .unknown,
                     shippingMethodPrices: [],
                     shippingCost: price,
                     auctions: [],
                     merchant: merchant,
                     categories: [],
                     audios: [],
                     images: self.images.map { $0.toWhoppahModel },
                     videos: self.videos.map { $0.toWhoppahModel },
                     arobject: self.arobject?.toWhoppahModel,
                     arobjects: [],
                     favorite: self.favorite?.toWhoppahModel,
                     favoriteCount: 0,
                     viewCount: 0,
                     shareLink: "",
                     fullImages: [],
                     thumbnails: [],
                     brands: [],
                     colors: [],
                     labels: [],
                     styles: [],
                     artists: [],
                     designers: [],
                     materials: [])
    }
}
