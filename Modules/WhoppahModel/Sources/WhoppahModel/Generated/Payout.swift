//
//  Payout.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Payout: Equatable {
	public let amount: Double
	public let currency: String
	public let created: Date

	public init(
		amount: Double,
		currency: String,
		created: Date
	) {
		self.amount = amount
		self.currency = currency
		self.created = created
	}
}
