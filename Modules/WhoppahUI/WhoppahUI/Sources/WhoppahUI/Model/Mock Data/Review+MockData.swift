//
//  Review+MockData.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 4.5.22..
//

import Foundation
import WhoppahModel

extension WhoppahModel.ProductReview {
    static var random: Self {
        .init(id: UUID(),
              review: RandomWord.randomWords(10...20),
              reviewerName: RandomWord.randomWords(2...3),
              anonymous: Int.random(in: 0...1) == 1,
              score: Int.random(in: 1...6),
              created: Date())
    }
}

