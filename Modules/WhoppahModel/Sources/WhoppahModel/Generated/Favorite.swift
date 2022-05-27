//
//  Favorite.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Favorite: Equatable & Hashable {
	public let id: UUID
	public let created: Date
	public let collection: FavoriteCollection?

	public init(
		id: UUID,
		created: Date,
		collection: FavoriteCollection? = nil
	) {
		self.id = id
		self.created = created
		self.collection = collection
	}
}
