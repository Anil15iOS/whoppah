//
//  AddressInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AddressInput {
	public let merchantId: UUID
	public let title: String?
	public let line1: String
	public let line2: String?
	public let postalCode: String
	public let city: String
	public let state: String?
	public let country: String
	public let location: LocationInput?
	// Custom parameter
	public var id: UUID?

	public init(
		merchantId: UUID,
		title: String? = nil,
		line1: String,
		line2: String? = nil,
		postalCode: String,
		city: String,
		state: String? = nil,
		country: String,
		location: LocationInput? = nil,
		id: UUID? = nil
	) {
		self.merchantId = merchantId
		self.title = title
		self.line1 = line1
		self.line2 = line2
		self.postalCode = postalCode
		self.city = city
		self.state = state
		self.country = country
		self.location = location
		self.id = id
	}
}
