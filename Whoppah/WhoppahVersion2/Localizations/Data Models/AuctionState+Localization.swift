//
//  AuctionState+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 25/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.AuctionState {
    class Localizer: EnumLocalizer<WhoppahModel.AuctionState> {
        override func localize(_ value: AuctionState) -> String {
            return "auction-state-\(value)".localized ?? ""
        }
    }
}
