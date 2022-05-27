//
//  ShippingMethodCountryPrice+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 02/05/2022.
//

import Foundation

extension ShippingMethodCountryPrice: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.country)
    }
}
