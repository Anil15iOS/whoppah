//
//  ReviewsRepository.swift
//  WhoppahRepository
//
//  Created by Marko Stojkovic on 4.5.22..
//

import Foundation
import WhoppahModel
import Combine

public protocol ReviewsRepository {
    func fetchReviews(merchantId: UUID) -> AnyPublisher<[ProductReview], Error>
}
