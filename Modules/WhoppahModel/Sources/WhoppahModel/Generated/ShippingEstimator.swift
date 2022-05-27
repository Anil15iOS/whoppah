//
//  ShippingEstimator.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ShippingEstimator {
	public let country: String
	public let postalCode: String?
	public let city: String?

	public init(
		country: String,
		postalCode: String? = nil,
		city: String? = nil
	) {
		self.country = country
		self.postalCode = postalCode
		self.city = city
	}
}
