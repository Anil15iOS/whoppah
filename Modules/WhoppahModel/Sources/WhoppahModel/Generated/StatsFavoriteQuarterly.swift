//
//  StatsFavoriteQuarterly.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsFavoriteQuarterly: Equatable {
	public let quarter: String
	public let favoriteCount: Int
	public let productCount: Int

	public init(
		quarter: String,
		favoriteCount: Int,
		productCount: Int
	) {
		self.quarter = quarter
		self.favoriteCount = favoriteCount
		self.productCount = productCount
	}
}
