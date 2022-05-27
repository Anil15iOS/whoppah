//
//  ARObject.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ARObject: Equatable {
	public let id: UUID
	public let url: String
	public let platform: ARPlatform

	public init(
		id: UUID,
		url: String,
		platform: ARPlatform
	) {
		self.id = id
		self.url = url
		self.platform = platform
	}
}
