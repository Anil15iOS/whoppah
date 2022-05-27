//
//  FavoriteResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct FavoriteResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Favorite]

	public init(
		pagination: PaginationResult,
		items: [Favorite]
	) {
		self.pagination = pagination
		self.items = items
	}
}
