//
//  ValidateVoucherInvalid.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ValidateVoucherInvalid: Equatable {
	public let invalid: Bool
	public let invalidReason: String

	public init(
		invalid: Bool,
		invalidReason: String
	) {
		self.invalid = invalid
		self.invalidReason = invalidReason
	}
}
