//
//  ProductQuality+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 01/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ProductQuality {
    class Localizer: EnumLocalizer<WhoppahModel.ProductQuality> {
        override func localize(_ value: WhoppahModel.ProductQuality) -> String {
            return "condition-\(value)".localized ?? ""
        }
    }
}
