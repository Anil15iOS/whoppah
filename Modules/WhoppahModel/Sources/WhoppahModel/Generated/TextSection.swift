//
//  TextSection.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct TextSection: Equatable {
	public let id: UUID
	public let slug: String
	public let title: String?
	public let description: String?
	public let button: String?
	public let link: String?
	public let image: String

	public init(
		id: UUID,
		slug: String,
		title: String? = nil,
		description: String? = nil,
		button: String? = nil,
		link: String? = nil,
		image: String
	) {
		self.id = id
		self.slug = slug
		self.title = title
		self.description = description
		self.button = button
		self.link = link
		self.image = image
	}
}
