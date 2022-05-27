//
//  CouponCodeDiscount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CouponCodeDiscount: Equatable {
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
