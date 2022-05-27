//
//  AuctionState+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.AuctionState {
    class MockLocalizer: EnumLocalizer<WhoppahModel.AuctionState> {
        override func localize(_ value: AuctionState) -> String {
            switch value {
            case .completed:
                return "SOLD"
            case .reserved:
                return "RESERVED"
            default:
                return missingLocalization(forValue: value)
            }
        }
    }
}
