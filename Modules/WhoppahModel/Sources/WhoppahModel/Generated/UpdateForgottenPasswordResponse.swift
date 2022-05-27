//
//  UpdateForgottenPasswordResponse.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct UpdateForgottenPasswordResponse: Equatable {
	public let status: UpdateForgottenPasswordResult
	public let message: String

	public init(
		status: UpdateForgottenPasswordResult,
		message: String
	) {
		self.status = status
		self.message = message
	}
}
