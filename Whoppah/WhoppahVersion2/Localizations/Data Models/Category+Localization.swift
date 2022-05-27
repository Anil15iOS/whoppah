//
//  Category+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 18/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Category {
    class Localizer: DataStoreLocalizer<WhoppahModel.Category> {
        override func localize(_ path: KeyPath<WhoppahModel.Category, String>,
                               model: WhoppahModel.Category,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "category-\(model.slug)".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
