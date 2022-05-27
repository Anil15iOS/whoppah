//
//  MediaCreateInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MediaCreateInput {
	public let type: MediaType?
	public let file: UUID
	public let contentType: ContentType?
	public let objectId: UUID?

	public init(
		type: MediaType? = nil,
		file: UUID,
		contentType: ContentType? = nil,
		objectId: UUID? = nil
	) {
		self.type = type
		self.file = file
		self.contentType = contentType
		self.objectId = objectId
	}
}
