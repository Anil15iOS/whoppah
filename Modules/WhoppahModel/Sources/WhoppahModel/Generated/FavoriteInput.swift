//
//  FavoriteInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct FavoriteInput {
	public let contentType: ContentType
	public let objectId: UUID
	public let collection: UUID?

	public init(
		contentType: ContentType,
		objectId: UUID,
		collection: UUID? = nil
	) {
		self.contentType = contentType
		self.objectId = objectId
		self.collection = collection
	}
}
