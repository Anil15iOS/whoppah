//
//  Style+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Style: DataStoreLocalizable {
    public func localize(_ path: KeyPath<Self, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.Style: Resolving {
    var localizer: DataStoreLocalizer<Self> {
        resolver.resolve()
    }
}
