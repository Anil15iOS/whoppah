//  
//  WhoppahReviews+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation

public extension WhoppahReviews.Model {
    static var mock: Self {
        let reviews =  [
            Review(avatar: "review_avatar_1",
                   reviewText: Lipsum.randomParagraph,
                   reviewerName: "Winston Gerschtanowitz",
                   image: "winston_truck",
                   rating: 4.5,
                   memberSince: "Member since 2019"),
            Review(avatar: nil,
                   reviewText: Lipsum.randomParagraph,
                   reviewerName: "Francis Vlasbloom",
                   image: nil,
                   rating: 4.0,
                   memberSince: "Member since 2019"),
            Review(avatar: "review_avatar_2",
                   reviewText: Lipsum.randomParagraph,
                   reviewerName: "Erwin Dis",
                   image: nil,
                   rating: 2.5,
                   memberSince: "Member since 2019")
            ]
        
        return Self(title: "Whoppah reviews",
                    description: Lipsum.randomParagraph,
                    reviews: reviews)
    }
}
