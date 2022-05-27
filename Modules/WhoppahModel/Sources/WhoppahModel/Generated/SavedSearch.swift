//
//  SavedSearch.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SavedSearch: Equatable {
	public let id: UUID
	public let title: String?
	public let query: String?
	public let link: String
	public let products: [Product]

	public init(
		id: UUID,
		title: String? = nil,
		query: String? = nil,
		link: String,
		products: [Product]
	) {
		self.id = id
		self.title = title
		self.query = query
		self.link = link
		self.products = products
	}
}
