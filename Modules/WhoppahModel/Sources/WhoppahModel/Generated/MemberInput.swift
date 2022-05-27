//
//  MemberInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MemberInput {
	public let email: String
	public let givenName: String
	public let familyName: String
	public let password: String?
	public let dob: Date?
	public var locale: Locale = .nlNl
	// Custom parameter
	public var id: UUID?

	public init(
		email: String,
		givenName: String,
		familyName: String,
		password: String? = nil,
		dob: Date? = nil,
		locale: Locale = .nlNl,
		id: UUID? = nil
	) {
		self.email = email
		self.givenName = givenName
		self.familyName = familyName
		self.password = password
		self.dob = dob
		self.locale = locale
		self.id = id
	}
}
