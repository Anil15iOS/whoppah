//
//  Category+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 21/03/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Category {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.Category> {
        override func localize(_ path: KeyPath<WhoppahModel.Category, String>,
                               model: WhoppahModel.Category,
                               params: [String]) -> String
        {
            return model[keyPath: path]
        }
    }
}
