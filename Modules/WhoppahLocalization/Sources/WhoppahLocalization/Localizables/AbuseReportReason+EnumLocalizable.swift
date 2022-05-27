//
//  AbuseReportReason+EnumLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 04/05/2022.
//

import Foundation
import WhoppahModel
import Resolver

extension WhoppahModel.AbuseReportReason: EnumLocalizable {
    public var localized: String {
        localizer.localize(self)
    }
}

extension WhoppahModel.AbuseReportReason: Resolving {
    var localizer: EnumLocalizer<WhoppahModel.AbuseReportReason> {
        resolver.resolve()
    }
}
