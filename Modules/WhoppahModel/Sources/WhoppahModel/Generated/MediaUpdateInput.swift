//
//  MediaUpdateInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MediaUpdateInput {
	public let position: Int?
	public let contentType: ContentType?
	public let type: String?
	public let objectId: UUID?

	public init(
		position: Int? = nil,
		contentType: ContentType? = nil,
		type: String? = nil,
		objectId: UUID? = nil
	) {
		self.position = position
		self.contentType = contentType
		self.type = type
		self.objectId = objectId
	}
}
