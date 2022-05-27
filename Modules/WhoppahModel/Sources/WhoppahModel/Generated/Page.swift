//
//  Page.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Page: Equatable {
	public let id: UUID
	public let parent: UUID?
	public let items: [Page]
	public let title: String
	public let slug: String

	public init(
		id: UUID,
		parent: UUID? = nil,
		items: [Page],
		title: String,
		slug: String
	) {
		self.id = id
		self.parent = parent
		self.items = items
		self.title = title
		self.slug = slug
	}
}
