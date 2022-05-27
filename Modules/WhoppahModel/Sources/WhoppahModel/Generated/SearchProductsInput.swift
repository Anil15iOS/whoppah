//
//  SearchProductsInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchProductsInput {
	public let query: String?
	public let pagination: Pagination?
	public var sortingtype: SortingType = .exhaustive
	public let sort: SearchSort?
	public let order: Ordering?
	public let facets: [SearchFacetKey]?
	public let filters: [FilterInput]?

	public init(
		query: String? = nil,
		pagination: Pagination? = nil,
		sortingtype: SortingType = .exhaustive,
		sort: SearchSort? = nil,
		order: Ordering? = nil,
		facets: [SearchFacetKey]? = nil,
		filters: [FilterInput]? = nil
	) {
		self.query = query
		self.pagination = pagination
		self.sortingtype = sortingtype
		self.sort = sort
		self.order = order
		self.facets = facets
		self.filters = filters
	}
}
