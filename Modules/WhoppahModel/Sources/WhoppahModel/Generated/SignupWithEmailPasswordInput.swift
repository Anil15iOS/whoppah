//
//  SignupWithEmailPasswordInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SignupWithEmailPasswordInput {
	public let email: String
	public let password: String
	public let type: MerchantType
	public let name: String
	public let phone: String
	public let givenName: String?
	public let familyName: String?
	public let address: SignupAddressInput?

	public init(
		email: String,
		password: String,
		type: MerchantType,
		name: String,
		phone: String,
		givenName: String? = nil,
		familyName: String? = nil,
		address: SignupAddressInput? = nil
	) {
		self.email = email
		self.password = password
		self.type = type
		self.name = name
		self.phone = phone
		self.givenName = givenName
		self.familyName = familyName
		self.address = address
	}
}
