//
//  LocationSearchFilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct LocationSearchFilterInput {
	public let latitude: Double?
	public let longitude: Double?
	public let address: String?
	public let distance: Int?

	public init(
		latitude: Double? = nil,
		longitude: Double? = nil,
		address: String? = nil,
		distance: Int? = nil
	) {
		self.latitude = latitude
		self.longitude = longitude
		self.address = address
		self.distance = distance
	}
}
