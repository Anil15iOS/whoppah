//
//  Label+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Label: DataStoreLocalizable {
    public func localize(_ path: KeyPath<WhoppahModel.Label, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.Label: Resolving {
    var localizer: DataStoreLocalizer<WhoppahModel.Label> {
        resolver.resolve()
    }
}
