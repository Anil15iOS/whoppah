//
//  ShippingMethod+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 02/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ShippingMethod {
    class Localizer: DataStoreLocalizer<WhoppahModel.ShippingMethod> {
        override func localize(_ path: KeyPath<WhoppahModel.ShippingMethod, String>,
                               model: WhoppahModel.ShippingMethod,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "shipping-method-\(model.slug)-title".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
