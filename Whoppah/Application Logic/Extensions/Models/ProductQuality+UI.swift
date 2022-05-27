//
//  Condition+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 06/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.ProductQuality {
    func explanationText() -> String {
        switch self {
        case .good:
            return R.string.localizable.create_ad_main_condition_value_d1()
        case .great:
            return R.string.localizable.create_ad_main_condition_value_d2()
        case .perfect:
            return R.string.localizable.create_ad_main_condition_value_d3()
        default:
            return ""
        }
    }

    func title() -> String {
        switch self {
        case .good:
            return R.string.localizable.create_ad_main_condition_value_1()
        case .great:
            return R.string.localizable.create_ad_main_condition_value_2()
        case .perfect:
            return R.string.localizable.create_ad_main_condition_value_3()
        default:
            return ""
        }
    }
}
