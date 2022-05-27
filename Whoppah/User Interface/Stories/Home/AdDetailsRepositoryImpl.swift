//
//  ProductDetailsRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore

class ProductDetailsRepositoryImpl: ProductDetailsRepository {
    private let provider: ServiceProvider
    private var watcher: GraphQLQueryWatcher<GraphQL.ProductQuery>?

    var productDetails: Observable<GraphQL.ProductQuery.Data.Product?> {
        _productDetails.asObservable()
    }

    let _productDetails = BehaviorSubject<GraphQL.ProductQuery.Data.Product?>(value: nil)

    private var similarItemsWatcher: GraphQLQueryWatcher<GraphQL.SimilarProductsQuery>?

    var similarItems: Observable<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]> {
        _similarProductDetails.asObservable()
    }

    let _similarProductDetails = BehaviorSubject<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]>(value: [])

    init(provider: ServiceProvider) {
        self.provider = provider
    }

    func fetchProduct(id: UUID) {
        if let watcher = watcher {
            return watcher.refetch()
        } else {
            watcher = provider.apollo.watch(query: GraphQL.ProductQuery(id: id, playlist: GraphQL.PlaylistType.hls), cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    guard let product = data.product else {
                        self?._productDetails.onError(AdDetailsFetchError.malformedResponse)
                        return
                    }
                    self?._productDetails.onNext(product)
                case let .failure(error):
                    self?._productDetails.onError(error)
                }
            }
        }
    }

    func fetchSimilarItems(product: UUID, user: UUID?) {
        if let watcher = similarItemsWatcher {
            return watcher.refetch()
        } else {
            similarItemsWatcher = provider.apollo.watch(query: GraphQL.SimilarProductsQuery(user: user, product: product), cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    self?._similarProductDetails.onNext(data.similarProducts.compactMap { $0 })
                case let .failure(error):
                    self?._similarProductDetails.onError(error)
                }
            }
        }
    }
}
