//
//  ApolloProductDetailsRepository.swift
//  
//
//  Created by Marko Stojkovic on 19.4.22..
//

import Foundation
import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel
import Foundation

class ApolloProductDetailsRepository: ProductDetailsRepository {
    
    @Injected private var apollo: ApolloService
    
    private var watcher: GraphQLQueryWatcher<GraphQL.ProductQuery>?
    private var similarItemsWatcher: GraphQLQueryWatcher<GraphQL.SimilarProductsQuery>?
    
    private let _productDetails = CurrentValueSubject<Product?, Error>(nil)
    private let _similarProductDetails = CurrentValueSubject<[Product], Error>([])
    
    var productDetails: AnyPublisher<Product?, Error> {
        _productDetails.eraseToAnyPublisher()
    }
    
    var similarItems: AnyPublisher<[Product], Error> {
        _similarProductDetails.eraseToAnyPublisher()
    }
    
    func watchProduct(id: UUID) {
        if let watcher = watcher {
            return watcher.refetch()
        } else {
            watcher = apollo.watch(query: GraphQL.ProductQuery(id: id,
                                                               playlist: GraphQL.PlaylistType.hls),
                                   cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    guard let product = data.product else {
                        self?._productDetails.send(completion: .failure(ProductDetailsFetchError.malformedResponse))
                        return
                    }
                    self?._productDetails.send(product.toWhoppahModel)
                case let .failure(error):
                    self?._productDetails.send(completion: .failure(error))
                }
            }
        }
    }
    
    func watchSimilarItems(product: UUID, user: UUID?) {
        if let watcher = similarItemsWatcher {
            return watcher.refetch()
        } else {
            let query = GraphQL.SimilarProductsQuery(user: user,
                                                     product: product)
            similarItemsWatcher = apollo.watch(query: query,
                                               cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    self?._similarProductDetails.send(data.similarProducts.compactMap( { $0.toWhoppahModel }))
                case let .failure(error):
                    self?._similarProductDetails.send(completion: .failure(error))
                }
            }
        }
    }
    
    func fetchProduct(id: UUID) -> AnyPublisher<Product, Error> {
        let query = GraphQL.ProductQuery(id: id,
                                         playlist: GraphQL.PlaylistType.hls)
        
        return self.apollo.fetch(query: query,
                                 cache: .returnCacheDataAndFetch)
        .tryMap { result -> Product in
            guard let product = result.data?.product else {
                throw ProductDetailsFetchError.malformedResponse
            }
            return product.toWhoppahModel
        }
        .eraseToAnyPublisher()
    }
    
    func fetchProduct(slug: String) -> AnyPublisher<Product, Error> {
        let query = GraphQL.ProductBySlugQuery(key: .slug,
                                               value: slug)
        
        return self.apollo.fetch(query: query,
                                 cache: .returnCacheDataAndFetch)
            .tryMap { result -> Product in
                guard let product = result.data?.productBySlug else {
                    throw ProductDetailsFetchError.malformedResponse
                }
                return product.toWhoppahModel
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSimilarItems(product: UUID, user: UUID?) -> AnyPublisher<[Product], Error> {
        let query = GraphQL.SimilarProductsQuery(user: user, product: product)
        
        return self.apollo.fetch(query: query,
                                 cache: .returnCacheDataAndFetch)
        .tryMap { result -> [WhoppahModel.Product] in
            guard let products = result.data?.similarProducts else {
                throw ProductDetailsFetchError.malformedResponse
            }
            return products.map { $0.toWhoppahModel }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchRelatedItems(product: String) -> AnyPublisher<[ProductTileItem], Error> {
        let query = GraphQL.GetRelatedProductsQuery(product_id: product)
        
        return self.apollo.fetch(query: query,
                                 cache: .returnCacheDataAndFetch)
        .tryMap { result -> [WhoppahModel.ProductTileItem] in
            guard let products = result.data?.relatedProducts else {
                throw ProductDetailsFetchError.malformedResponse
            }
            return products.map { $0.toWhoppahModel }
        }
        .eraseToAnyPublisher()
    }
}
