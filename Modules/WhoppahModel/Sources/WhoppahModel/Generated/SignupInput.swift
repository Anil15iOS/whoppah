//
//  SignupInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SignupInput {
	public let email: String
	public let password: String

	public init(
		email: String,
		password: String
	) {
		self.email = email
		self.password = password
	}
}
