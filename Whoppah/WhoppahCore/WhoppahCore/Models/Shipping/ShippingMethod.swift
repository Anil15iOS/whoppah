//
//  ShippingMethod.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol ShippingMethod {
    var id: UUID { get }
    var slug: String { get }
    var pricing: Price { get }
}

public struct ShippingMethodInput {
    public let method: ShippingMethod?
    public let price: PriceInput?

    public init(method: ShippingMethod?, price: PriceInput?) {
        self.method = method
        self.price = price
    }
}

public let customShippingSlug = "custom"
