//
//  UpdateCartInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct UpdateCartInput {
	public let deliveryMethod: DeliveryMethod?
	public let paymentMethod: PaymentMethod?
	public let couponCode: String?
	public let addressId: UUID?
	public let buyerProtection: Bool?

	public init(
		deliveryMethod: DeliveryMethod? = nil,
		paymentMethod: PaymentMethod? = nil,
		couponCode: String? = nil,
		addressId: UUID? = nil,
		buyerProtection: Bool? = nil
	) {
		self.deliveryMethod = deliveryMethod
		self.paymentMethod = paymentMethod
		self.couponCode = couponCode
		self.addressId = addressId
		self.buyerProtection = buyerProtection
	}
}
