//
//  ShippingMethodCountryPrice+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.ShippingMethodCountryPrice: DataStoreLocalizable {
    public func localize(_ path: KeyPath<WhoppahModel.ShippingMethodCountryPrice, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.ShippingMethodCountryPrice: Resolving {
    var localizer: DataStoreLocalizer<WhoppahModel.ShippingMethodCountryPrice> {
        Resolver.resolve()
    }
}
