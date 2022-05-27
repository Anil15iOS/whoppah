//
//  PriceSearchFilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PriceSearchFilterInput {
	public let currency: Currency?
	public let from: Double?
	public let to: Double?

	public init(
		currency: Currency? = nil,
		from: Double? = nil,
		to: Double? = nil
	) {
		self.currency = currency
		self.from = from
		self.to = to
	}
}
