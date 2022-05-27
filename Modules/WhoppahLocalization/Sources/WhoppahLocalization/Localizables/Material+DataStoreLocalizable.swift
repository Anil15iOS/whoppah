//
//  Material+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Material: DataStoreLocalizable {
    public func localize(_ path: KeyPath<Self, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.Material: Resolving {
    var localizer: DataStoreLocalizer<Self> {
        resolver.resolve()
    }
}
