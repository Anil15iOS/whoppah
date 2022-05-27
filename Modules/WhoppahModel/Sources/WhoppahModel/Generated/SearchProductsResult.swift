//
//  SearchProductsResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchProductsResult: Equatable {
	public let facets: [SearchFacet]?
	public let pagination: PaginationResult?
	public let items: [Product]?
	public let queryid: String?
	public let indexname: String?

	public init(
		facets: [SearchFacet]? = nil,
		pagination: PaginationResult? = nil,
		items: [Product]? = nil,
		queryid: String? = nil,
		indexname: String? = nil
	) {
		self.facets = facets
		self.pagination = pagination
		self.items = items
		self.queryid = queryid
		self.indexname = indexname
	}
}
