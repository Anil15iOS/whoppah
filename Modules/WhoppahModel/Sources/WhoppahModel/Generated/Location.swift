//
//  Location.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Location: Equatable {
	public let latitude: Double
	public let longitude: Double

	public init(
		latitude: Double,
		longitude: Double
	) {
		self.latitude = latitude
		self.longitude = longitude
	}
}
