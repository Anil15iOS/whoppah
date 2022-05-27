//
//  Country.swift
//  Whoppah
//
//  Created by Eddie Long on 03/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import FlagPhoneNumber
import Foundation

enum Country: String, CaseIterable {
    case netherlands = "NL"
    case belgium = "BE"
    case gb = "GB"
    case germany = "DE"
    case france = "FR"
    case italy = "IT"
}

extension Country {
    var title: String {
        switch self {
        case .netherlands:
            return R.string.localizable.common_netherlands()
        case .belgium:
            return R.string.localizable.common_belgium()
        case .gb:
            return R.string.localizable.commonGb()
        case .germany:
            return R.string.localizable.common_germany()
        case .france:
            return R.string.localizable.common_france()
        case .italy:
            return R.string.localizable.common_italy()
        }
    }
}

extension Country {
    static var phoneCodes: [FPNCountryCode] {
        Country.allCases.map {
            guard let code = FPNCountryCode(rawValue: $0.rawValue) else {
                fatalError("Expected all country code to map directly to a phone country code")
            }
            return code
        }
    }
}
