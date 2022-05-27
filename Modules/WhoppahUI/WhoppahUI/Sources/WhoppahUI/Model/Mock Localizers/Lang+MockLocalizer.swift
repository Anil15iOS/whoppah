//
//  Lang+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 03/05/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Lang {
    class MockLocalizer: EnumLocalizer<WhoppahModel.Lang> {
        override func localize(_ value: Lang) -> String {
            switch value {
            case .de: return "German"
            case .en: return "English"
            case .es: return "Spanish"
            case .fr: return "French"
            case .nl: return "Dutch"
            default:
                return missingLocalization(forValue: value)
            }
        }
    }
}
