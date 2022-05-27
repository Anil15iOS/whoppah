//
//  Price.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol Price {
    var currency: GraphQL.Currency { get }
    var amount: Double { get }
}

extension Price {
    public func asInput() -> PriceInput {
        PriceInput(currency: currency, amount: amount)
    }

    public func asGraphInput() -> GraphQL.PriceInput {
        GraphQL.PriceInput(amount: amount, currency: currency)
    }
}

public struct PriceInput: Price {
    public let currency: GraphQL.Currency
    public let amount: Double

    public init(currency: GraphQL.Currency, amount: Double) {
        self.amount = amount
        self.currency = currency
    }

    public init(price: Price) {
        amount = price.amount
        currency = price.currency
    }
}
