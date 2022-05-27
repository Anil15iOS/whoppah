//
//  WhoppahUI+FavoritesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation
import WhoppahModel
import ComposableArchitecture

public extension WhoppahUI {
    struct FavoritesClient {
        public typealias CreateFavoriteClosure = (FavoriteInput) -> Effect<FavoritedProduct, Error>
        public typealias RemoveFavoriteClosure = (UUID, Favorite) -> Effect<FavoritedProduct, Error>
        public typealias CurrentUserFavoritesClosure = () -> Effect<[UUID: Favorite], Error>
        
        var createFavorite: CreateFavoriteClosure
        var removeFavorite: RemoveFavoriteClosure
        var currentUserFavorites: CurrentUserFavoritesClosure
        
        public init(createFavorite: @escaping CreateFavoriteClosure,
                    removeFavorite: @escaping RemoveFavoriteClosure,
                    currentUserFavorites: @escaping CurrentUserFavoritesClosure)
        {
            self.createFavorite = createFavorite
            self.removeFavorite = removeFavorite
            self.currentUserFavorites = currentUserFavorites
        }
    }
}
