//  
//  WhoppahReviews+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation
import SwiftUI

public extension WhoppahReviews {
    struct Model: Equatable {
        public struct Review: Equatable, Hashable {
            public let uuid = UUID()
            
            public let avatar: String?
            public let reviewText: String // review-text-x 1 - 10
            public let reviewerName: String
            public let image: String?
            public let rating: Double
            public let memberSince: String // review-members-year
            
            public init(avatar: String?,
                        reviewText: String,
                        reviewerName: String,
                        image: String?,
                        rating: Double,
                        memberSince: String)
            {
                self.avatar = avatar
                self.reviewText = reviewText
                self.reviewerName = reviewerName
                self.image = image
                self.rating = rating
                self.memberSince = memberSince
            }

            public static func == (lhs: Review, rhs: Review) -> Bool {
                return lhs.uuid == rhs.uuid
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(uuid.uuidString)
            }
        }
        
        public let title: String // reviews-title
        public let description: String // reviews-description
        public let reviews: [Review]
        
        public init(title: String,
                    description: String,
                    reviews: [Review])
        {
            self.title = title
            self.description = description
            self.reviews = reviews
        }
        
        static var initial = Self(title: "",
                                  description: "",
                                  reviews: [])
    }
}
