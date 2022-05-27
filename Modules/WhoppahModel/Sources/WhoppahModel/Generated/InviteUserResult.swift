//
//  InviteUserResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct InviteUserResult: Equatable {
	public let success: Bool
	public let message: String

	public init(
		success: Bool,
		message: String
	) {
		self.success = success
		self.message = message
	}
}
