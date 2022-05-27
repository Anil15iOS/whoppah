//
//  Label+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 25/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation

import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Label {
    class Localizer: DataStoreLocalizer<WhoppahModel.Label> {
        override func localize(_ path: KeyPath<WhoppahModel.Label, String>,
                               model: WhoppahModel.Label,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "label-\(model.slug)".localized ?? ""
            case \.hex!:
                return "label-\(model.slug)-color".localized ?? ""
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}
