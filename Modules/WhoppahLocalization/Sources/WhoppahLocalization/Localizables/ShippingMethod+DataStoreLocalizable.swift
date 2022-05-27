//
//  ShippingMethod+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.ShippingMethod: DataStoreLocalizable {
    public func localize(_ path: KeyPath<WhoppahModel.ShippingMethod, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.ShippingMethod: Resolving {
    var localizer: DataStoreLocalizer<WhoppahModel.ShippingMethod> {
        Resolver.resolve()
    }
}
