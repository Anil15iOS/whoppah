//
//  Currency.swift
//  WhoppahCore
//
//  Created by Eddie Long on 03/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.Currency {
    public var text: String {
        switch self {
        case .eur:
            return "€"
        case .usd:
            return "$"
        case .gbp:
            return "£"
        case .__unknown:
            return "€"
        }
    }
}
