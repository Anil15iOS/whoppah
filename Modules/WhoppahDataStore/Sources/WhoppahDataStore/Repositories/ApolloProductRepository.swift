//
//  ApolloProductRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation
import WhoppahRepository
import WhoppahModel
import Resolver
import Combine

public struct ApolloProductRepository: ProductRepository {
    @Injected private var apollo: ApolloService
    
    public func createFavorite(_ input: FavoriteInput) -> AnyPublisher<FavoritedProduct, Error> {
        let mutation = GraphQL.CreateFavoriteMutation(input: input.toGraphQLModel)
        return apollo.apply(mutation: mutation)
            .tryMap { result in
                guard let product = result.data?.createFavorite.item.asProduct,
                      let favorite = product.favorite
                else {
                    throw WhoppahRepository.Error.noData
                }
                return FavoritedProduct(productId: product.id,
                                        favorite: favorite.toWhoppahModel)
            }
            .eraseToAnyPublisher()
    }
    
    public func removeFavorite(id: UUID, favorite: Favorite) -> AnyPublisher<FavoritedProduct, Error> {
        let mutation = GraphQL.RemoveFavoriteMutation(id: favorite.id)
        return apollo.apply(mutation: mutation)
            .tryMap { result in
                guard let _ = result.data?.removeFavorite else {
                    throw WhoppahRepository.Error.noData
                }
                return .init(productId: id,
                             favorite: favorite)
            }
            .eraseToAnyPublisher()
    }
}
