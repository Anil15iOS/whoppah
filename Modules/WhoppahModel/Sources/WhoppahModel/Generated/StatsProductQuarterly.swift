//
//  StatsProductQuarterly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsProductQuarterly: Equatable {
	public let quarter: String
	public let totalProducts: Int
	public let soldProducts: Int
	public let canceledProducts: Int
	public let bannedProducts: Int
	public let activeProducts: Int
	public let draftProducts: Int
	public let curationProducts: Int
	public let rejectedProducts: Int
	public let averageSoldAfter: Double

	public init(
		quarter: String,
		totalProducts: Int,
		soldProducts: Int,
		canceledProducts: Int,
		bannedProducts: Int,
		activeProducts: Int,
		draftProducts: Int,
		curationProducts: Int,
		rejectedProducts: Int,
		averageSoldAfter: Double
	) {
		self.quarter = quarter
		self.totalProducts = totalProducts
		self.soldProducts = soldProducts
		self.canceledProducts = canceledProducts
		self.bannedProducts = bannedProducts
		self.activeProducts = activeProducts
		self.draftProducts = draftProducts
		self.curationProducts = curationProducts
		self.rejectedProducts = rejectedProducts
		self.averageSoldAfter = averageSoldAfter
	}
}
