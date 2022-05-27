//
//  ProductsRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahModel
import Combine

public protocol ProductsRepository {
    func fetchProducts(filters: [ProductFilter],
                       pagination: Pagination,
                       sort: ProductSort,
                       ordering: Ordering) -> AnyPublisher<[ProductTileItem], Error>
}
