//
//  StatsByProductCategory.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByProductCategory: Equatable {
	public let category: String
	public let totalCount: Int
	public let activeCount: Int
	public let soldCount: Int
	public let salesVolume: Double
	public let averageOrderValue: Double
	public let averageSoldAfter: Double

	public init(
		category: String,
		totalCount: Int,
		activeCount: Int,
		soldCount: Int,
		salesVolume: Double,
		averageOrderValue: Double,
		averageSoldAfter: Double
	) {
		self.category = category
		self.totalCount = totalCount
		self.activeCount = activeCount
		self.soldCount = soldCount
		self.salesVolume = salesVolume
		self.averageOrderValue = averageOrderValue
		self.averageSoldAfter = averageSoldAfter
	}
}
