//
//  StatsUserMonthly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsUserMonthly: Equatable {
	public let monthYear: String
	public let totalSignups: Int
	public let individualSignups: Int
	public let businessSignups: Int

	public init(
		monthYear: String,
		totalSignups: Int,
		individualSignups: Int,
		businessSignups: Int
	) {
		self.monthYear = monthYear
		self.totalSignups = totalSignups
		self.individualSignups = individualSignups
		self.businessSignups = businessSignups
	}
}
