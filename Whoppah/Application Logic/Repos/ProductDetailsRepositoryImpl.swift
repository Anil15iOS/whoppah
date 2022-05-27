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
import Resolver
import WhoppahDataStore

class ProductDetailsRepositoryImpl: LegacyProductDetailsRepository {
    private var watcher: GraphQLQueryWatcher<GraphQL.ProductQuery>?
    
    @Injected private var apollo: ApolloService

    var productDetails: Observable<GraphQL.ProductQuery.Data.Product?> {
        _productDetails.asObservable()
    }

    let _productDetails = BehaviorSubject<GraphQL.ProductQuery.Data.Product?>(value: nil)

    private var similarItemsWatcher: GraphQLQueryWatcher<GraphQL.SimilarProductsQuery>?

    var similarItems: Observable<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]> {
        _similarProductDetails.asObservable()
    }

    let _similarProductDetails = BehaviorSubject<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]>(value: [])
    private let bag = DisposeBag()

    init() {}

    func watchProduct(id: UUID) {
        if let watcher = watcher {
            return watcher.refetch()
        } else {
            watcher = apollo.watch(query: GraphQL.ProductQuery(id: id, playlist: GraphQL.PlaylistType.hls), cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    guard let product = data.product else {
                        self?._productDetails.onError(ProductDetailsFetchError.malformedResponse)
                        return
                    }
                    self?._productDetails.onNext(product)
                case let .failure(error):
                    self?._productDetails.onError(error)
                }
            }
        }
    }

    func fetchProduct(id: UUID) -> Observable<GraphQL.ProductQuery.Data.Product> {
        Observable.create { observer in
            self.apollo.fetch(query: GraphQL.ProductQuery(id: id, playlist: GraphQL.PlaylistType.hls), cache: .fetchIgnoringCacheData).subscribe(onNext: { result in
                guard let product = result.data?.product else {
                    observer.onError(ProductDetailsFetchError.malformedResponse)
                    return
                }

                observer.onNext(product)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    func watchSimilarItems(product: UUID, user: UUID?) {
        if let watcher = similarItemsWatcher {
            return watcher.refetch()
        } else {
            let query = GraphQL.SimilarProductsQuery(user: user, product: product)
            similarItemsWatcher = apollo.watch(query: query, cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    self?._similarProductDetails.onNext(data.similarProducts.compactMap { $0 })
                case let .failure(error):
                    self?._similarProductDetails.onError(error)
                }
            }
        }
    }

    func fetchSimilarItems(product: UUID, user: UUID?) -> Observable<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]> {
        Observable.create { observer in
            let query = GraphQL.SimilarProductsQuery(user: user, product: product)
            self.apollo.fetch(query: query).subscribe(onNext: { result in
                guard let similarProducts = result.data?.similarProducts else {
                    observer.onError(ProductDetailsFetchError.malformedResponse)
                    return
                }

                observer.onNext(similarProducts)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
    func fetchRelatedItems(product: String) -> Observable<[GraphQL.GetRelatedProductsQuery.Data.RelatedProduct]> {
        Observable.create { observer in
            let query = GraphQL.GetRelatedProductsQuery(product_id: product)
            self.apollo.fetch(query: query).subscribe(onNext: { result in
                guard let related = result.data?.relatedProducts else {
                    observer.onError(ProductDetailsFetchError.malformedResponse)
                    return
                }
                observer.onNext(related)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
}
