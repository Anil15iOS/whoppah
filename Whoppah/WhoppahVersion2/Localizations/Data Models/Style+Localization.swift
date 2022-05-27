//
//  Style+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 30/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Style {
    class Localizer: DataStoreLocalizer<WhoppahModel.Style> {
        override func localize(_ path: KeyPath<WhoppahModel.Style, String>,
                               model: WhoppahModel.Style,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "style-\(model.slug)".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
