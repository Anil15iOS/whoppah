//
//  WhoppahUI+MockFavoritesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation
import ComposableArchitecture

extension WhoppahUI.FavoritesClient {
    static let mockFavoritesClient = WhoppahUI.FavoritesClient { favoriteInput in
        return Effect(value: .init(productId: favoriteInput.objectId,
                                   favorite: .init(id: UUID(),
                                                   created: Date())))
    } removeFavorite: { productId, favorite in
        return Effect(value: .init(productId: productId,
                                   favorite: favorite))
    } currentUserFavorites: {
        return Effect(value: [UUID(): .init(id: UUID(), created: Date(), collection: nil)]) 
    }
}
