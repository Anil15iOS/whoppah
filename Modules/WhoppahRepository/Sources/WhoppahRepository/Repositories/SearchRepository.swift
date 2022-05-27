//
//  SearchRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 17/03/2022.
//

import Foundation
import Combine
import WhoppahModel

public protocol SearchRepository {
    func search(input: SearchProductsInput) -> AnyPublisher<ProductSearchResultsSet, Error>
    func saveSearch(input: SearchProductsInput) -> AnyPublisher<Bool, Error>
}
