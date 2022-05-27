//
//  MerchantInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantInput {
	public let type: MerchantType
	public let name: String
	public let biography: String?
	public let url: String?
	public let phone: String?
	public let email: String?
	public let businessName: String?
	public let taxId: String?
	public let vatId: String?
	public let vatIdRegistrar: String?
	public var currency: Currency = .eur
	// Custom parameter
	public var id: UUID?

	public init(
		type: MerchantType,
		name: String,
		biography: String? = nil,
		url: String? = nil,
		phone: String? = nil,
		email: String? = nil,
		businessName: String? = nil,
		taxId: String? = nil,
		vatId: String? = nil,
		vatIdRegistrar: String? = nil,
		currency: Currency = .eur,
		id: UUID? = nil
	) {
		self.type = type
		self.name = name
		self.biography = biography
		self.url = url
		self.phone = phone
		self.email = email
		self.businessName = businessName
		self.taxId = taxId
		self.vatId = vatId
		self.vatIdRegistrar = vatIdRegistrar
		self.currency = currency
		self.id = id
	}
}
