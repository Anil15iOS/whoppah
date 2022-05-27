//
//  ProductReview.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation

public struct ProductReview: Equatable, Identifiable {
    public let id: UUID
    public let review: String?
    public let reviewerName: String?
    public let anonymous: Bool
    public let score: Int?
    public let created: Date?
    
    public init(id: UUID,
                review: String?,
                reviewerName: String?,
                anonymous: Bool,
                score: Int?,
                created: Date?)
    {
        self.id = id
        self.review = review
        self.reviewerName = reviewerName
        self.anonymous = anonymous
        self.score = score
        self.created = created
    }
}
