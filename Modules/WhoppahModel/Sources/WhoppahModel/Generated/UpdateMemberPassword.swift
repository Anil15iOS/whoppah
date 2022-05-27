//
//  UpdateMemberPassword.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct UpdateMemberPassword {
	public let current: String?
	public let password: String?

	public init(
		current: String? = nil,
		password: String? = nil
	) {
		self.current = current
		self.password = password
	}
}
