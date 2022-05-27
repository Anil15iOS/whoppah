//
//  PriceInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PriceInput {
	public let amount: Double
	public let currency: Currency

	public init(
		amount: Double,
		currency: Currency
	) {
		self.amount = amount
		self.currency = currency
	}
}
