//
//  ProductQuality+EnumLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 01/05/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.ProductQuality: EnumLocalizable {
    public var localized: String {
        localizer.localize(self)
    }
}

extension WhoppahModel.ProductQuality: Resolving {
    var localizer: EnumLocalizer<WhoppahModel.ProductQuality> {
        Resolver.resolve()
    }
}
