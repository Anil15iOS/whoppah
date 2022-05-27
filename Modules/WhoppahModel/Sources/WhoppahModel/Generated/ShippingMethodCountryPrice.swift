//
//  ShippingMethodCountryPrice.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ShippingMethodCountryPrice: Equatable {
	public let country: String
	public let price: Price

	public init(
		country: String,
		price: Price
	) {
		self.country = country
		self.price = price
	}
}
