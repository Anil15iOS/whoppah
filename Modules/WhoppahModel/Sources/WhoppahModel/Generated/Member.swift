//
//  Member.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Member: Equatable {
	public let id: UUID
	public let email: String
	public let givenName: String
	public let familyName: String
	public let dateJoined: Date
	public let lastLogin: Date?
	public let locale: Locale
	public let dob: Date?
	public let merchants: [Merchant]
	// Temporary while switching between new and old architures. Will hold GraphQL object.
	@IgnoreEquatable public var rawObject: AnyObject?

	public init(
		id: UUID,
		email: String,
		givenName: String,
		familyName: String,
		dateJoined: Date,
		lastLogin: Date? = nil,
		locale: Locale,
		dob: Date? = nil,
		merchants: [Merchant],
		rawObject: AnyObject? = nil
	) {
		self.id = id
		self.email = email
		self.givenName = givenName
		self.familyName = familyName
		self.dateJoined = dateJoined
		self.lastLogin = lastLogin
		self.locale = locale
		self.dob = dob
		self.merchants = merchants
		self.rawObject = rawObject
	}
}
