//
//  ShowRoomOrderInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ShowRoomOrderInput {
	public let productId: UUID?
	public let paymentMethod: PaymentMethod?
	public let paymentMethodId: String?
	public let addressId: UUID?
	public let couponCode: String?
	public let usePaymentIntents: Bool?

	public init(
		productId: UUID? = nil,
		paymentMethod: PaymentMethod? = nil,
		paymentMethodId: String? = nil,
		addressId: UUID? = nil,
		couponCode: String? = nil,
		usePaymentIntents: Bool? = nil
	) {
		self.productId = productId
		self.paymentMethod = paymentMethod
		self.paymentMethodId = paymentMethodId
		self.addressId = addressId
		self.couponCode = couponCode
		self.usePaymentIntents = usePaymentIntents
	}
}
