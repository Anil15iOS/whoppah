//
//  ShippingMethodCountryPrice+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ShippingMethodCountryPrice {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethodCountryPrice> {
        override func localize(_ path: KeyPath<ShippingMethodCountryPrice, String>,
                               model: ShippingMethodCountryPrice,
                               params: [String]) -> String
        {
            return model[keyPath: path]
        }
    }
}
