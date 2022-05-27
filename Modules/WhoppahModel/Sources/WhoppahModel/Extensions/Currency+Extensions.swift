//
//  Currency+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 28/03/2022.
//

import Foundation

public extension WhoppahModel.Currency {
    var text: String {
        switch self {
        case .eur:
            return "€"
        case .usd:
            return "$"
        case .gbp:
            return "£"
        case .unknown:
            return "€"
        }
    }
}
