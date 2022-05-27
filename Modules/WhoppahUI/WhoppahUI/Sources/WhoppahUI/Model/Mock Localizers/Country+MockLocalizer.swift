//
//  Country+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 06/04/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.Country {
    class MockLocalizer: EnumLocalizer<WhoppahModel.Country> {
        override func localize(_ value: Country) -> String {
            switch value {
            case .at: return "Austria"
            case .be: return "Belgium"
            case .de: return "Germany"
            case .fr: return "France"
            case .nl: return "The Netherlands"
            case .uk: return "United Kingdom"
            case .us: return "United States"
            default:
                return missingLocalization(forValue: value)
            }
        }
    }
}
