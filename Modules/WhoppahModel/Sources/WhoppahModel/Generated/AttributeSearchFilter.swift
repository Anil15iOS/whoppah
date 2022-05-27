//
//  AttributeSearchFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AttributeSearchFilter: Equatable {
	public let title: String
	public let slug: String
	public let items: [AttributeSearchFilterItem]

	public init(
		title: String,
		slug: String,
		items: [AttributeSearchFilterItem]
	) {
		self.title = title
		self.slug = slug
		self.items = items
	}
}
