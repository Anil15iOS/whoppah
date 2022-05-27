//
//  Price.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Price: Equatable {
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
