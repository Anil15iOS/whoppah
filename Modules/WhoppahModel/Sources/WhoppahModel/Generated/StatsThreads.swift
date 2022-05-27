//
//  StatsThreads.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsThreads: Equatable {
	public let quarterly: [StatsThreadsQuarterly]
	public let monthly: [StatsThreadsMonthly]

	public init(
		quarterly: [StatsThreadsQuarterly],
		monthly: [StatsThreadsMonthly]
	) {
		self.quarterly = quarterly
		self.monthly = monthly
	}
}
