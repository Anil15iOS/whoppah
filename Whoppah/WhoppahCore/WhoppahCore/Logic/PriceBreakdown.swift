//
//  PriceBreakdown.swift
//  Whoppah
//
//  Created by Eddie Long on 16/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public struct PriceBreakdown {
    public let price: Price
    public let whoppahFee: Price
    public let type: GraphQL.CalculationMethod
    public let whoppahPercentage: Double?
    public let vat: Price
    public let vatRate: Double
    public let total: Price
}

public func getPriceBreakdown(member: LegacyMember, price: PriceInput?) -> PriceBreakdown {
    let currency = price?.currency ?? .eur
    let thePrice = price?.amount ?? 0
    var whoppahFee: Double!
    var feeType = GraphQL.CalculationMethod.percentage
    var percentage: Double = 0.0
    let vatRate = member.mainMerchant.vatRate
    if let fee = member.mainMerchant.fees {
        feeType = fee.type
        switch fee.type {
        case .fixed:
            whoppahFee = fee.amount
        case .percentage:
            whoppahFee = thePrice * (fee.amount / 100.0)
            percentage = fee.amount
        default: whoppahFee = 0.0
        }
    } else {
        whoppahFee = 0.0
    }
    var vat: Money = 0.0
    if member.isProfessional, vatRate > Double.ulpOfOne {
        vat = whoppahFee * (vatRate / 100.0)
    }
    let total = thePrice - whoppahFee - vat
    return PriceBreakdown(price: PriceInput(currency: currency, amount: thePrice),
                          whoppahFee: PriceInput(currency: currency, amount: whoppahFee),
                          type: feeType,
                          whoppahPercentage: percentage,
                          vat: PriceInput(currency: currency, amount: vat),
                          vatRate: vatRate,
                          total: PriceInput(currency: currency, amount: total))
}
