//
//  StatsProductItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsProductItem: Equatable {
	public let monthly: [StatsProductMonthly]
	public let quarterly: [StatsProductQuarterly]

	public init(
		monthly: [StatsProductMonthly],
		quarterly: [StatsProductQuarterly]
	) {
		self.monthly = monthly
		self.quarterly = quarterly
	}
}
