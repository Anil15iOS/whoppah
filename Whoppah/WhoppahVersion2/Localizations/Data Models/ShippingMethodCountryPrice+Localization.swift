//
//  ShippingMethodCountryPrice+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 02/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ShippingMethodCountryPrice {
    class Localizer: DataStoreLocalizer<WhoppahModel.ShippingMethodCountryPrice> {
        override func localize(_ path: KeyPath<ShippingMethodCountryPrice, String>,
                               model: ShippingMethodCountryPrice, params: [String]) -> String
        {
            switch path {
            case \.country:
                return "country-\(model.country.lowercased())".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
