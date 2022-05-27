//
//  UsageSign.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct UsageSign: AbstractAttribute & Equatable & Hashable {
	public let id: UUID
	public let title: String
	public let description: String?
	public let slug: String

	public init(
		id: UUID,
		title: String,
		description: String? = nil,
		slug: String
	) {
		self.id = id
		self.title = title
		self.description = description
		self.slug = slug
	}
}
