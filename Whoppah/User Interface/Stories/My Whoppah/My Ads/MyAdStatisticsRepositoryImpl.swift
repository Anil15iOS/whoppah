//
//  MyAdStatisticsRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 11/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class MyAdStatisticsRepositoryImpl: MyAdStatisticsRepository {
    private var watcher: GraphQLQueryWatcher<GraphQL.ProductQuery>?
    
    @Injected private var apollo: ApolloService

    var productDetails: Observable<GraphQL.ProductQuery.Data.Product?> {
        _productDetails.asObservable()
    }

    let _productDetails = BehaviorSubject<GraphQL.ProductQuery.Data.Product?>(value: nil)

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
}
