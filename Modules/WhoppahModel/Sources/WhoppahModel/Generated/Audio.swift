//
//  Audio.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Audio: Equatable {
	public let id: UUID
	public let url: String
	public let type: AudioType
	public let thumbnail: String

	public init(
		id: UUID,
		url: String,
		type: AudioType,
		thumbnail: String
	) {
		self.id = id
		self.url = url
		self.type = type
		self.thumbnail = thumbnail
	}
}
