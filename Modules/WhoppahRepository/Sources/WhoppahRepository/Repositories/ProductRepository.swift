//
//  ProductRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation
import WhoppahModel
import Combine

public protocol ProductRepository {
    func createFavorite(_ input: FavoriteInput) -> AnyPublisher<FavoritedProduct, Error>
    func removeFavorite(id: UUID, favorite: Favorite) -> AnyPublisher<FavoritedProduct, Error>
}
