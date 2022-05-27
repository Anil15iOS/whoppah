//
//  StatsFavoriteMonthly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsFavoriteMonthly: Equatable {
	public let monthYear: String
	public let favoriteCount: Int
	public let productCount: Int

	public init(
		monthYear: String,
		favoriteCount: Int,
		productCount: Int
	) {
		self.monthYear = monthYear
		self.favoriteCount = favoriteCount
		self.productCount = productCount
	}
}
