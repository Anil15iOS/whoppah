//
//  ProductDetailsRepository.swift
//  WhoppahRepository
//
//  Created by Marko Stojkovic on 19.4.22..
//

import Combine
import Foundation
import WhoppahModel

public protocol ProductDetailsRepository {
    
    var productDetails: AnyPublisher<Product?, Error> { get }
    func watchProduct(id: UUID)
    func fetchProduct(id: UUID) -> AnyPublisher<Product, Error>
    func fetchProduct(slug: String) -> AnyPublisher<Product, Error>
    
    var similarItems: AnyPublisher<[Product], Error> { get }
    func watchSimilarItems(product: UUID,
                           user: UUID?)
    func fetchSimilarItems(product: UUID,
                           user: UUID?) -> AnyPublisher<[Product], Error>
    func fetchRelatedItems(product: String) -> AnyPublisher<[ProductTileItem], Error>
}
