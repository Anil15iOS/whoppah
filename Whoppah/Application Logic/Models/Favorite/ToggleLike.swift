//
//  ToggleLike.swift
//  Whoppah
//
//  Created by Eddie Long on 10/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

struct ToggleLike {
    /// Returns the new like status
    @discardableResult
    static func toggleProductLikeStatus(apollo: ApolloService, productId: UUID, favoriteId: UUID?) -> Observable<Bool> {
        let query = GraphQL.ProductQuery(id: productId, playlist: .hls)
        if let id = favoriteId {
            let mutation = GraphQL.RemoveFavoriteMutation(id: id)
            return apollo.apply(mutation: mutation, query: query, storeTransaction: { (_, cachedQuery: inout GraphQL.ProductQuery.Data) in
                cachedQuery.product?.favorite = nil
            }).map { result in
                if result.data?.removeFavorite != nil {
                    let newId: UUID? = nil
                    NotificationCenter.default.post(name: adLikeChange, object: nil, userInfo: [adIdObject: productId, adFavoriteId: newId as Any])

                    return false
                }
                // Remains as favorite otherwise
                return true
            }
        } else {
            let input = GraphQL.FavoriteInput(contentType: .product, objectId: productId)
            return apollo.apply(mutation: GraphQL.CreateFavoriteMutation(input: input), query: query, storeTransaction: { (mutationResult, cachedQuery: inout GraphQL.ProductQuery.Data) in
                guard let id = mutationResult.data?.createFavorite.item.asProduct?.favorite?.id else { return }
                cachedQuery.product?.favorite = GraphQL.ProductQuery.Data.Product.Favorite(id: id)
            }).map { result in

                let id = result.data?.createFavorite.item.asProduct?.favorite?.id
                let isFavorite = id != nil
                NotificationCenter.default.post(name: adLikeChange, object: nil, userInfo: [adIdObject: productId, adFavoriteId: id as Any])

                return isFavorite
            }
        }
    }
}
