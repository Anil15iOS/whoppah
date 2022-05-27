//
//  OrderInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct OrderInput {
	public var purchaseType: PurchaseType = .bid
	public let bidId: UUID?
	public let productId: UUID?
	public let paymentMethod: PaymentMethod?
	public let paymentMethodId: String?
	public let deliveryMethod: DeliveryMethod?
	public let shippingMethodId: UUID?
	public let addressId: UUID?
	public let couponCode: String?
	public let buyerProtection: Bool?
	public let usePaymentIntents: Bool?

	public init(
		purchaseType: PurchaseType = .bid,
		bidId: UUID? = nil,
		productId: UUID? = nil,
		paymentMethod: PaymentMethod? = nil,
		paymentMethodId: String? = nil,
		deliveryMethod: DeliveryMethod? = nil,
		shippingMethodId: UUID? = nil,
		addressId: UUID? = nil,
		couponCode: String? = nil,
		buyerProtection: Bool? = nil,
		usePaymentIntents: Bool? = nil
	) {
		self.purchaseType = purchaseType
		self.bidId = bidId
		self.productId = productId
		self.paymentMethod = paymentMethod
		self.paymentMethodId = paymentMethodId
		self.deliveryMethod = deliveryMethod
		self.shippingMethodId = shippingMethodId
		self.addressId = addressId
		self.couponCode = couponCode
		self.buyerProtection = buyerProtection
		self.usePaymentIntents = usePaymentIntents
	}
}
