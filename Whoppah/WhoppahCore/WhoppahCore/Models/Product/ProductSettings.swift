//
//  ProductSettings.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct ProductSettingsInput {
    public let allowBidding: Bool
    public let allowBuyNow: Bool
    public let minBid: PriceInput?
    public init(allowBidding: Bool, allowBuyNow: Bool, minBid: PriceInput? = nil) {
        self.allowBidding = allowBidding
        self.allowBuyNow = allowBuyNow
        self.minBid = minBid
    }
}
