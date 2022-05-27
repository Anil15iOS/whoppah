//
//  productServiceOrderInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct productServiceOrderInput {
	public let productId: UUID?
	public let paymentMethod: PaymentMethod?
	public let paymentMethodId: String?
	public let usePaymentIntents: Bool?
	public let serviceId: UUID?

	public init(
		productId: UUID? = nil,
		paymentMethod: PaymentMethod? = nil,
		paymentMethodId: String? = nil,
		usePaymentIntents: Bool? = nil,
		serviceId: UUID? = nil
	) {
		self.productId = productId
		self.paymentMethod = paymentMethod
		self.paymentMethodId = paymentMethodId
		self.usePaymentIntents = usePaymentIntents
		self.serviceId = serviceId
	}
}
