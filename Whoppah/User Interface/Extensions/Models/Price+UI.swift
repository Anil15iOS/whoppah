//
//  Price+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 29/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

private func getFormattedPrice(includeCurrency: Bool = true,
                               showFraction: Bool = false,
                               clipRemainderIfZero: Bool = false,
                               amount: Double,
                               currency: GraphQL.Currency) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    if includeCurrency {
        formatter.currencySymbol = currency.text
    } else {
        formatter.currencySymbol = ""
    }

    // If there's a remainder then we use different formatting
    if !amount.hasRemainder(), clipRemainderIfZero {
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
    } else {
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = showFraction ? 2 : 0
    }

    let result = formatter.string(from: NSNumber(value: amount))

    return result ?? currency.text + "-"
}

extension Price {
    func formattedPrice(includeCurrency: Bool = true, clipRemainderIfZero: Bool = false, showFraction: Bool = false) -> String {
        getFormattedPrice(includeCurrency: includeCurrency,
                          showFraction: showFraction,
                          clipRemainderIfZero: clipRemainderIfZero,
                          amount: amount,
                          currency: currency)
    }
}

extension PriceInput {
    func formattedPrice(includeCurrency: Bool = true, clipRemainderIfZero: Bool = false, showFraction: Bool = false) -> String {
        getFormattedPrice(includeCurrency: includeCurrency,
                          showFraction: showFraction,
                          clipRemainderIfZero: clipRemainderIfZero,
                          amount: amount,
                          currency: currency)
    }
}

extension Money {
    func formattedPrice(includeCurrency: Bool = true, showFraction: Bool = false, currency: GraphQL.Currency) -> String {
        getFormattedPrice(includeCurrency: includeCurrency, showFraction: showFraction, amount: self, currency: currency)
    }
}
