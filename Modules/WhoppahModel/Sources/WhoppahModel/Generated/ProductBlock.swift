//
//  ProductBlock.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ProductBlock: AbstractBlock & Equatable {
	public let id: UUID
	public let title: String
	public let slug: String
	public let summary: String?
	public let image: String
	public let link: String?
	public let location: BlockLocation?
	public let products: [Product]

	public init(
		id: UUID,
		title: String,
		slug: String,
		summary: String? = nil,
		image: String,
		link: String? = nil,
		location: BlockLocation? = nil,
		products: [Product]
	) {
		self.id = id
		self.title = title
		self.slug = slug
		self.summary = summary
		self.image = image
		self.link = link
		self.location = location
		self.products = products
	}
}
