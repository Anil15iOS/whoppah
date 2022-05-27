//
//  EmailTokenLoginResponse.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct EmailTokenLoginResponse: Equatable {
	public let token: String
	public let redirecturl: String
	public let user: Member

	public init(
		token: String,
		redirecturl: String,
		user: Member
	) {
		self.token = token
		self.redirecturl = redirecturl
		self.user = user
	}
}
