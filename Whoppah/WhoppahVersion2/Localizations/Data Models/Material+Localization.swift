//
//  Material+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 30/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Material {
    class Localizer: DataStoreLocalizer<WhoppahModel.Material> {
        override func localize(_ path: KeyPath<Material, String>,
                               model: Material, params: [String]) -> String
        {
            switch path {
            case \.title:
                return "material-\(model.slug)".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
