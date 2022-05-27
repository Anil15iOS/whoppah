//
//  AbuseReportReason+MockLocalizer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/05/2022.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.AbuseReportReason {
    class MockLocalizer: EnumLocalizer<WhoppahModel.AbuseReportReason> {
        override func localize(_ value: AbuseReportReason) -> String {
            switch value {
            case .violatingContent:
                return "Content is inappropriate"
            case .poorPhotoQuality:
                return "Poor photo quality"
            case .spam:
                return "Spam"
            case .wrongCategory:
                return "Incorrectly classified"
            default:
                return missingLocalization(forValue: value)
            }
        }
    }
}
