//
//  StatsBuyersVsOrdersItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBuyersVsOrdersItem: Equatable {
	public let monthYear: String
	public let orderCount: Int
	public let buyerCount: Int
	public let averageLife: Double

	public init(
		monthYear: String,
		orderCount: Int,
		buyerCount: Int,
		averageLife: Double
	) {
		self.monthYear = monthYear
		self.orderCount = orderCount
		self.buyerCount = buyerCount
		self.averageLife = averageLife
	}
}
