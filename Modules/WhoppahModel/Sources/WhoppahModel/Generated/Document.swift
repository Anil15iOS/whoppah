//
//  Document.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Document: Equatable {
	public let id: UUID
	public let url: String
	public let type: DocumentType
	public let thumbnail: String

	public init(
		id: UUID,
		url: String,
		type: DocumentType,
		thumbnail: String
	) {
		self.id = id
		self.url = url
		self.type = type
		self.thumbnail = thumbnail
	}
}
