//
//  Material+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Material {
    class MockLocalizer: DataStoreLocalizer<WhoppahModel.Material> {
        override func localize(_ path: KeyPath<Material, String>,
                               model: Material,
                               params: [String]) -> String
        {
            return model[keyPath: path]
        }
    }
}
