//
//  Video.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Video: Equatable {
	public let id: UUID
	public let url: String
	public let thumbnail: String
	public let type: VideoType

	public init(
		id: UUID,
		url: String,
		thumbnail: String,
		type: VideoType
	) {
		self.id = id
		self.url = url
		self.thumbnail = thumbnail
		self.type = type
	}
}
