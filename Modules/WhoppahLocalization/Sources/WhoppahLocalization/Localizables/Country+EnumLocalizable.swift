//
//  Country+EnumLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 06/04/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Country: EnumLocalizable {
    public var localized: String {
        localizer.localize(self)
    }
}

extension WhoppahModel.Country: Resolving {
    var localizer: EnumLocalizer<WhoppahModel.Country> {
        resolver.resolve()
    }
}
