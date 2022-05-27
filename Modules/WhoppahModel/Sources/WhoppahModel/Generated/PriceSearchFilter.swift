//
//  PriceSearchFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PriceSearchFilter: Equatable {
	public let currency: Currency?
	public let from: Double
	public let to: Double

	public init(
		currency: Currency? = nil,
		from: Double,
		to: Double
	) {
		self.currency = currency
		self.from = from
		self.to = to
	}
}
