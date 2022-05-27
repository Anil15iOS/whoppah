//
//  Lang+EnumLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 03/05/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.Lang: EnumLocalizable {
    public var localized: String {
        localizer.localize(self)
    }
}

extension WhoppahModel.Lang: Resolving {
    var localizer: EnumLocalizer<WhoppahModel.Lang> {
        resolver.resolve()
    }
}
