//
//  Lang+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 03/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Lang {
    class Localizer: EnumLocalizer<WhoppahModel.Lang> {
        override func localize(_ value: WhoppahModel.Lang) -> String {
            return "language-\(value.rawValue.lowercased())".localized ?? ""
        }
    }
}
