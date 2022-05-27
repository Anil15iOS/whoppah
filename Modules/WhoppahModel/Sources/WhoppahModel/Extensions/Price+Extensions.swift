//
//  Price+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 28/03/2022.
//

import Foundation

public extension Price {
    var formattedString: String {
        let formatter = NumberFormatter()       
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency.text
        
        let formattedAmount = formatter.string(from: amount as NSNumber) ?? "\(amount)"
        
        return formattedAmount
    }
}
