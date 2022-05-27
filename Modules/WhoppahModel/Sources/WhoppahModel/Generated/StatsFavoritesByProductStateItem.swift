//
//  StatsFavoritesByProductStateItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsFavoritesByProductStateItem: Equatable {
	public let maxFavoriteCount: Int
	public let minFavoriteCount: Int
	public let averageFavoriteCount: Double

	public init(
		maxFavoriteCount: Int,
		minFavoriteCount: Int,
		averageFavoriteCount: Double
	) {
		self.maxFavoriteCount = maxFavoriteCount
		self.minFavoriteCount = minFavoriteCount
		self.averageFavoriteCount = averageFavoriteCount
	}
}
