//
//  Category+DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 21/03/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Category: DataStoreLocalizable {
    public func localize(_ path: KeyPath<WhoppahModel.Category, String>,
                         params: String...) -> String
    {
        localizer.localize(path, model: self, params: params)
    }
}

extension WhoppahModel.Category: Resolving {
    var localizer: DataStoreLocalizer<WhoppahModel.Category> {
        resolver.resolve()
    }
}
