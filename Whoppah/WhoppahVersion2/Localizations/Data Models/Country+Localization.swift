//
//  Country+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 06/04/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Country {
    class Localizer: EnumLocalizer<WhoppahModel.Country> {
        override func localize(_ value: WhoppahModel.Country) -> String {
            return "country-\(value)".localized ?? ""
        }
    }
}
