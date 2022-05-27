//
//  PaymentInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PaymentInput {
	public let usePaymentIntents: Bool?
	public let paymentMethod: PaymentMethod
	public let paymentMethodId: String?
	public let deliveryMethod: DeliveryMethod?
	public let shippingMethodId: UUID?
	public let addressId: UUID?
	public let couponCode: String?
	public let buyerProtection: Bool?

	public init(
		usePaymentIntents: Bool? = nil,
		paymentMethod: PaymentMethod,
		paymentMethodId: String? = nil,
		deliveryMethod: DeliveryMethod? = nil,
		shippingMethodId: UUID? = nil,
		addressId: UUID? = nil,
		couponCode: String? = nil,
		buyerProtection: Bool? = nil
	) {
		self.usePaymentIntents = usePaymentIntents
		self.paymentMethod = paymentMethod
		self.paymentMethodId = paymentMethodId
		self.deliveryMethod = deliveryMethod
		self.shippingMethodId = shippingMethodId
		self.addressId = addressId
		self.couponCode = couponCode
		self.buyerProtection = buyerProtection
	}
}
