//
//  CategoryRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 26/11/2021.
//

import Foundation
import Combine
import WhoppahModel

public protocol CategoryRepository {
    func loadCategories(atLevel level: Int) -> AnyPublisher<[WhoppahModel.Category], Error>
    /// We want to change the order of the categories shown to the ones with most supply. This will improve conversion.
    /// Currently we have for example 'Storage' listed as second, with only 5 products in it. Please change the way we show the
    /// categories on based on product count. https://whoppah.atlassian.net/browse/WTP-76
    func subcategories(categorySlug: String?, style: String?, brand: String?) -> AnyPublisher<[WhoppahModel.Category], Error>
}
