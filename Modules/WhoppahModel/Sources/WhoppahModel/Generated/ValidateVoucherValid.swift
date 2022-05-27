//
//  ValidateVoucherValid.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ValidateVoucherValid: Equatable {
	public let type: DiscountType
	public let value: Double

	public init(
		type: DiscountType,
		value: Double
	) {
		self.type = type
		self.value = value
	}
}
