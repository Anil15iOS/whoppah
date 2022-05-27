//
//  ApplyCouponCodeResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ApplyCouponCodeResult: Equatable {
	public let type: DiscountType?
	public let value: Double?
	public let invalid: Bool?
	public let invalidReason: String?

	public init(
		type: DiscountType? = nil,
		value: Double? = nil,
		invalid: Bool? = nil,
		invalidReason: String? = nil
	) {
		self.type = type
		self.value = value
		self.invalid = invalid
		self.invalidReason = invalidReason
	}
}
