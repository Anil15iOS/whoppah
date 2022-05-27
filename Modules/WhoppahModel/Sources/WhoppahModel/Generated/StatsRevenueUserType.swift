//
//  StatsRevenueUserType.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsRevenueUserType: Equatable {
	public let monthly: [StatsRevenueMonthly]
	public let quarterly: [StatsRevenueQuarterly]

	public init(
		monthly: [StatsRevenueMonthly],
		quarterly: [StatsRevenueQuarterly]
	) {
		self.monthly = monthly
		self.quarterly = quarterly
	}
}
