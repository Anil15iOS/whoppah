//  
//  MerchantProductsView+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import SwiftUI
import WhoppahModel

public extension MerchantProductsView {
    struct Model: Equatable {
        let allItemsFromTitle: String
        let userNotSignedInTitle: String
        let userNotSignedInDescription: String
        @IgnoreEquatable
        var bidFromTitle: (Price) -> String
        
        static var initial = Self(allItemsFromTitle: .empty,
                                  userNotSignedInTitle: .empty,
                                  userNotSignedInDescription: .empty,
                                  bidFromTitle: { _ in .empty })
        
        public init(allItemsFromTitle: String,
                    userNotSignedInTitle: String,
                    userNotSignedInDescription: String,
                    bidFromTitle: @escaping (Price) -> String)
        {
            self.allItemsFromTitle = allItemsFromTitle
            self.userNotSignedInTitle = userNotSignedInTitle
            self.userNotSignedInDescription = userNotSignedInDescription
            self.bidFromTitle = bidFromTitle
        }
    }
}
