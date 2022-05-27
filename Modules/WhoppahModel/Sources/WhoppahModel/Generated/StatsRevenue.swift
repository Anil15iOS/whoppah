//
//  StatsRevenue.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsRevenue: Equatable {
	public let buyers: StatsRevenueUserType
	public let sellers: StatsRevenueUserType

	public init(
		buyers: StatsRevenueUserType,
		sellers: StatsRevenueUserType
	) {
		self.buyers = buyers
		self.sellers = sellers
	}
}
