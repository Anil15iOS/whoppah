//
//  Image.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Image: Equatable {
	public let id: UUID
	public let url: String
	public let type: ImageType
	public let orientation: ImageOrientation?
	public let width: Int?
	public let height: Int?
	public let aspectRatio: Double?
	public let position: Int
	public let backgroundColor: String?

	public init(
		id: UUID,
		url: String,
		type: ImageType,
		orientation: ImageOrientation? = nil,
		width: Int? = nil,
		height: Int? = nil,
		aspectRatio: Double? = nil,
		position: Int,
		backgroundColor: String? = nil
	) {
		self.id = id
		self.url = url
		self.type = type
		self.orientation = orientation
		self.width = width
		self.height = height
		self.aspectRatio = aspectRatio
		self.position = position
		self.backgroundColor = backgroundColor
	}
}
