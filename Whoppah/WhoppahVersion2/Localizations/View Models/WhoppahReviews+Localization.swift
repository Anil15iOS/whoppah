//
//  WhoppahReviews+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 10/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahUI
import WhoppahLocalization

extension WhoppahReviews.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let reviews = [
            Review(avatar: "review_avatar_1",
                   reviewText: l.reviewText1(),
                   reviewerName: "Winston Gerschtanowitz",
                   image: "winston_truck",
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2019"),
            Review(avatar: nil,
                   reviewText: l.reviewText2(),
                   reviewerName: "Francis Vlasblom",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2019"),
            Review(avatar: nil,
                   reviewText: l.reviewText3(),
                   reviewerName: "Dries Lommers",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2019"),
            Review(avatar: nil,
                   reviewText: l.reviewText4(),
                   reviewerName: "Cees Dijkema",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2019"),
            Review(avatar: "review_avatar_2",
                   reviewText: l.reviewText5(),
                   reviewerName: "Erwin Dis",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2019"),
            Review(avatar: nil,
                   reviewText: l.reviewText6(),
                   reviewerName: "Christian Reinsma",
                   image: nil,
                   rating: 5.0,
                   memberSince: l.reviewMembersYear() + " 2020"),
            Review(avatar: "review_avatar_3",
                   reviewText: l.reviewText7(),
                   reviewerName: "Caroline Tensen",
                   image: nil,
                   rating: 5.0,
                   memberSince: l.reviewMembersYear() + " 2021"),
            Review(avatar: nil,
                   reviewText: l.reviewText8(),
                   reviewerName: "Enid de Weever",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2020"),
            Review(avatar: nil,
                   reviewText: l.reviewText9(),
                   reviewerName: "Louwrens Dijkstra",
                   image: nil,
                   rating: 4.5,
                   memberSince: l.reviewMembersYear() + " 2020"),
            Review(avatar: nil,
                   reviewText: l.reviewText10(),
                   reviewerName: "Henriette",
                   image: nil,
                   rating: 5.0,
                   memberSince: l.reviewMembersYear() + " 2020")
        ]
        
        return .init(title: l.reviewsTitle(),
                     description: l.reviewsDescription(),
                     reviews: reviews)
    }
}
