//
//  LegacyProductDetailsRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

enum ProductDetailsFetchError: Error {
    case malformedResponse
}

protocol LegacyProductDetailsRepository {
    var productDetails: Observable<GraphQL.ProductQuery.Data.Product?> { get }
    func watchProduct(id: UUID)
    func fetchProduct(id: UUID) -> Observable<GraphQL.ProductQuery.Data.Product>

    var similarItems: Observable<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]> { get }
    func watchSimilarItems(product: UUID, user: UUID?)
    func fetchSimilarItems(product: UUID, user: UUID?) -> Observable<[GraphQL.SimilarProductsQuery.Data.SimilarProduct]>
    func fetchRelatedItems(product: String) -> Observable<[GraphQL.GetRelatedProductsQuery.Data.RelatedProduct]>
}
