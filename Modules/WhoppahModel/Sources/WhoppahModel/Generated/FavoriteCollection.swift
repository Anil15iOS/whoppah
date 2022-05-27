//
//  FavoriteCollection.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct FavoriteCollection: Equatable & Hashable {
	public let id: UUID
	public let title: String
	public let items: [Favorite]

	public init(
		id: UUID,
		title: String,
		items: [Favorite]
	) {
		self.id = id
		self.title = title
		self.items = items
	}
}
