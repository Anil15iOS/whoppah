//
//  LocationSearchFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct LocationSearchFilter: Equatable {
	public let latitude: Double?
	public let longitude: Double?
	public let distance: Int?

	public init(
		latitude: Double? = nil,
		longitude: Double? = nil,
		distance: Int? = nil
	) {
		self.latitude = latitude
		self.longitude = longitude
		self.distance = distance
	}
}
