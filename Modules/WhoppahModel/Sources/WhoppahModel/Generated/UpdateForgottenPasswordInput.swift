//
//  UpdateForgottenPasswordInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct UpdateForgottenPasswordInput {
	public let uid: String
	public let token: String
	public let newPassword: String
	public let newPasswordConfirmation: String

	public init(
		uid: String,
		token: String,
		newPassword: String,
		newPasswordConfirmation: String
	) {
		self.uid = uid
		self.token = token
		self.newPassword = newPassword
		self.newPasswordConfirmation = newPasswordConfirmation
	}
}
