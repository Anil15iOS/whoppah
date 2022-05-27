//  
//  MerchantProductsView+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation

public extension MerchantProductsView.Model {
    static var mock: Self {
        return Self(allItemsFromTitle: "All items from",
                    userNotSignedInTitle: "Please sign in",
                    userNotSignedInDescription: "Sign in description",
                    bidFromTitle: { priceString in "Bid from \(priceString)" })
    }
}
