//
//  StatsThreadsMonthly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsThreadsMonthly: Equatable {
	public let monthYear: String
	public let totalThreads: Int
	public let convertedThreads: Int
	public let totalMessageCount: Int
	public let totalBidCount: Int
	public let totalOrderCount: Int
	public let averageMessageCount: Double
	public let averageBidCount: Double
	public let averageOrderCount: Double

	public init(
		monthYear: String,
		totalThreads: Int,
		convertedThreads: Int,
		totalMessageCount: Int,
		totalBidCount: Int,
		totalOrderCount: Int,
		averageMessageCount: Double,
		averageBidCount: Double,
		averageOrderCount: Double
	) {
		self.monthYear = monthYear
		self.totalThreads = totalThreads
		self.convertedThreads = convertedThreads
		self.totalMessageCount = totalMessageCount
		self.totalBidCount = totalBidCount
		self.totalOrderCount = totalOrderCount
		self.averageMessageCount = averageMessageCount
		self.averageBidCount = averageBidCount
		self.averageOrderCount = averageOrderCount
	}
}
