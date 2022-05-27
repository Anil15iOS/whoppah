//
//  ForgotPasswordResponse.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ForgotPasswordResponse: Equatable {
	public let status: ForgotPasswordResult
	public let message: String

	public init(
		status: ForgotPasswordResult,
		message: String
	) {
		self.status = status
		self.message = message
	}
}
