//
//  SavedSearchInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SavedSearchInput {
	public let title: String?
	public let query: String?
	public let filters: SearchFilterInput?

	public init(
		title: String? = nil,
		query: String? = nil,
		filters: SearchFilterInput? = nil
	) {
		self.title = title
		self.query = query
		self.filters = filters
	}
}
