//
//  StatsRevenueQuarterly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsRevenueQuarterly: Equatable {
	public let quarter: String
	public let count: Int
	public let averageItems: Double
	public let averageFee: Double
	public let averageShipping: Double
	public let averagePayment: Double
	public let averageSubtotal: Double
	public let averageTotal: Double

	public init(
		quarter: String,
		count: Int,
		averageItems: Double,
		averageFee: Double,
		averageShipping: Double,
		averagePayment: Double,
		averageSubtotal: Double,
		averageTotal: Double
	) {
		self.quarter = quarter
		self.count = count
		self.averageItems = averageItems
		self.averageFee = averageFee
		self.averageShipping = averageShipping
		self.averagePayment = averagePayment
		self.averageSubtotal = averageSubtotal
		self.averageTotal = averageTotal
	}
}
