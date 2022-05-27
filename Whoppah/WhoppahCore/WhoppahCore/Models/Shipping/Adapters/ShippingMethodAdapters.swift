//
//  ShippingMethodAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.ShippingMethod.Price: WhoppahCore.Price {}
extension GraphQL.ProductQuery.Data.Product.ShippingMethod: ShippingMethod {
    public var pricing: WhoppahCore.Price { price }
    public var description: String? { nil }
}

extension GraphQL.GetShippingMethodsQuery.Data.ShippingMethod.Price: WhoppahCore.Price {}
extension GraphQL.GetShippingMethodsQuery.Data.ShippingMethod: ShippingMethod {
    public var pricing: WhoppahCore.Price { price }
}
