//
//  Style+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Style {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.Style> {
        override func localize(_ path: KeyPath<Style, String>,
                               model: Style,
                               params: [String]) -> String
        {
            return model[keyPath: path]
        }
    }
}
