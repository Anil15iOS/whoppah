//
//  SearchResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchResult: Equatable {
	public let query: String
	public let attributes: [AttributeSearchFilter]
	public let categories: CategorySearchFilter
	public let pagination: PaginationResult

	public init(
		query: String,
		attributes: [AttributeSearchFilter],
		categories: CategorySearchFilter,
		pagination: PaginationResult
	) {
		self.query = query
		self.attributes = attributes
		self.categories = categories
		self.pagination = pagination
	}
}
