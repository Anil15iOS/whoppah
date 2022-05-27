//
//  PriceFormatter.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation

struct PriceFormatter: TextInputFormattable {
    func format(_ input: String) -> String {
        guard let value = Int(input) else { return input }
        
        return String(value)
    }
}
