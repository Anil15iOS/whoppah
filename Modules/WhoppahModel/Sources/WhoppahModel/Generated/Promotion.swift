//
//  Promotion.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Promotion: Equatable {
	public let code: String
	public let discount: CouponCodeDiscount
	public let validUpto: Date?

	public init(
		code: String,
		discount: CouponCodeDiscount,
		validUpto: Date? = nil
	) {
		self.code = code
		self.discount = discount
		self.validUpto = validUpto
	}
}
