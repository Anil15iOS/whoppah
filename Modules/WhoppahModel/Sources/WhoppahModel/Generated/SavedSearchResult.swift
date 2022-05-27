//
//  SavedSearchResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SavedSearchResult: Equatable {
	public let pagination: PaginationResult
	public let items: [SavedSearch]

	public init(
		pagination: PaginationResult,
		items: [SavedSearch]
	) {
		self.pagination = pagination
		self.items = items
	}
}
