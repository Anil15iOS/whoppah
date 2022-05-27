//
//  StatsUsers.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsUsers: Equatable {
	public let monthly: [StatsUserMonthly]
	public let quarterly: [StatsUserQuarterly]

	public init(
		monthly: [StatsUserMonthly],
		quarterly: [StatsUserQuarterly]
	) {
		self.monthly = monthly
		self.quarterly = quarterly
	}
}
