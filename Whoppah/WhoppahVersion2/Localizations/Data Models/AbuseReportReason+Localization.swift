//
//  AbuseReportReason+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 04/05/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahLocalization

extension WhoppahModel.AbuseReportReason {
    class Localizer: EnumLocalizer<WhoppahModel.AbuseReportReason> {
        override func localize(_ value: WhoppahModel.AbuseReportReason) -> String {
            switch value {
            case .wrongCategory:
                return "report_product_incorrectly_classified".localized ?? ""
            case .spam:
                return "report_product_spam".localized ?? ""
            case .violatingContent:
                return "report_product_inappropriate_content".localized ?? ""
            case .poorPhotoQuality:
                return "report_product_poor_photo_quality".localized ?? ""
            default:
                return missingLocalization(forValue: value)
            }
        }
    }
}
