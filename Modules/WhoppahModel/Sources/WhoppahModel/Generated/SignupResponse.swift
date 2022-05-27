//
//  SignupResponse.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SignupResponse: Equatable {
	public let accessToken: String
	public let user: Member

	public init(
		accessToken: String,
		user: Member
	) {
		self.accessToken = accessToken
		self.user = user
	}
}
