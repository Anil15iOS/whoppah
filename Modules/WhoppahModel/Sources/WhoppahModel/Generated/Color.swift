//
//  Color.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Color: AbstractAttribute & Equatable & Hashable {
	public let id: UUID
	public let title: String
	public let description: String?
	public let slug: String
	public let hex: String

	public init(
		id: UUID,
		title: String,
		description: String? = nil,
		slug: String,
		hex: String
	) {
		self.id = id
		self.title = title
		self.description = description
		self.slug = slug
		self.hex = hex
	}
}
