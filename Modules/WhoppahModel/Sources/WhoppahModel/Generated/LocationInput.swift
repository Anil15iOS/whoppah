//
//  LocationInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct LocationInput {
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
