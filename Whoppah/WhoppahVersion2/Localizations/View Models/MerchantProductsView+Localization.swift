//
//  MerchantProductsView+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 05/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization
import WhoppahModel

extension MerchantProductsView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(allItemsFromTitle: l.allItemsFromMerchant(),
                     userNotSignedInTitle: l.contextualSignupFavoritesTitle(),
                     userNotSignedInDescription: l.contextualSignupFavoritesDescription(),
                     bidFromTitle: { priceString in l.commonBidFromPrice(priceString.formattedString) })
    }
}
