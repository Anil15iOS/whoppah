//
//  ProductQuality+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 01/05/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.ProductQuality {
    class MockLocalizer: EnumLocalizer<WhoppahModel.ProductQuality> {
        override func localize(_ value: ProductQuality) -> String {
            switch value {
            case .good: return "Good"
            case .great: return "Great"
            case .perfect: return "Perfect"
            default: return missingLocalization(forValue: value)
            }
        }
    }
}
