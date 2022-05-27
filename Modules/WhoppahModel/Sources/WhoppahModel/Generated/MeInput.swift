//
//  MeInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MeInput {
	public let email: String?
	public let givenName: String?
	public let familyName: String?
	public let name: String?
	public let businessName: String?
	public let referrer: Referrer?
	public let phone: String?
	public let dob: Date?
	public let locale: Locale?
	public let type: MerchantType?

	public init(
		email: String? = nil,
		givenName: String? = nil,
		familyName: String? = nil,
		name: String? = nil,
		businessName: String? = nil,
		referrer: Referrer? = nil,
		phone: String? = nil,
		dob: Date? = nil,
		locale: Locale? = nil,
		type: MerchantType? = nil
	) {
		self.email = email
		self.givenName = givenName
		self.familyName = familyName
		self.name = name
		self.businessName = businessName
		self.referrer = referrer
		self.phone = phone
		self.dob = dob
		self.locale = locale
		self.type = type
	}
}
