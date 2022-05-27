//
//  StatsUserQuarterly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsUserQuarterly: Equatable {
	public let quarter: String
	public let totalSignups: Int
	public let individualSignups: Int
	public let businessSignups: Int

	public init(
		quarter: String,
		totalSignups: Int,
		individualSignups: Int,
		businessSignups: Int
	) {
		self.quarter = quarter
		self.totalSignups = totalSignups
		self.individualSignups = individualSignups
		self.businessSignups = businessSignups
	}
}
