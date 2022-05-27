//
//  Review+Conversion.swift
//  WhoppahDataStore
//
//  Created by Marko Stojkovic on 4.5.22..
//

import Foundation
import WhoppahModel

extension GraphQL.GetReviewsQuery.Data.Review.Item: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.ProductReview {
        .init(id: self.id,
              review: self.review,
              reviewerName: self.reviewer?.name,
              anonymous: self.anonymous ?? true,
              score: self.score,
              created: self.created)
    }
}
