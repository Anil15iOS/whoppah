//
//  SignupAddressInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SignupAddressInput {
	public let line1: String
	public let line2: String?
	public let postalCode: String
	public let city: String
	public let state: String?
	public let country: String
	public let location: LocationInput?

	public init(
		line1: String,
		line2: String? = nil,
		postalCode: String,
		city: String,
		state: String? = nil,
		country: String,
		location: LocationInput? = nil
	) {
		self.line1 = line1
		self.line2 = line2
		self.postalCode = postalCode
		self.city = city
		self.state = state
		self.country = country
		self.location = location
	}
}
