//
//  AuctionState+EnumLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.AuctionState: EnumLocalizable {
    public var localized: String {
        localizer.localize(self)
    }
}

extension WhoppahModel.AuctionState: Resolving {
    var localizer: EnumLocalizer<WhoppahModel.AuctionState> {
        resolver.resolve()
    }
}
