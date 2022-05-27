//
//  Brand.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Brand: AbstractAttribute & AbstractActor & Equatable & Hashable {
	public let id: UUID
	public let title: String
	public let description: String?
	public let slug: String
	public let countryOfOrigin: String?

	public init(
		id: UUID,
		title: String,
		description: String? = nil,
		slug: String,
		countryOfOrigin: String? = nil
	) {
		self.id = id
		self.title = title
		self.description = description
		self.slug = slug
		self.countryOfOrigin = countryOfOrigin
	}
}
