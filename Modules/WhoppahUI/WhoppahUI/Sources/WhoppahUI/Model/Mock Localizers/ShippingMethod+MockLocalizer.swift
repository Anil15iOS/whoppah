//
//  ShippingMethod+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ShippingMethod {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethod> {
        override func localize(_ path: KeyPath<WhoppahModel.ShippingMethod, String>,
                               model: WhoppahModel.ShippingMethod,
                               params: [String]) -> String
        {
            return model[keyPath: path]
        }
    }
}
