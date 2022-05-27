//
//  Cart.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Cart: Equatable {
	public let id: UUID
	public let created: Date
	public let updated: Date
	public let items: [CartItem]
	public let couponCode: String?
	public let deliveryMethod: DeliveryMethod
	public let paymentMethod: PaymentMethod
	public let buyerProtection: Bool?
	public let address: Address?
	public let availableCouponCodes: [CouponCode]
	public let totals: OrderTotals?

	public init(
		id: UUID,
		created: Date,
		updated: Date,
		items: [CartItem],
		couponCode: String? = nil,
		deliveryMethod: DeliveryMethod,
		paymentMethod: PaymentMethod,
		buyerProtection: Bool? = nil,
		address: Address? = nil,
		availableCouponCodes: [CouponCode],
		totals: OrderTotals? = nil
	) {
		self.id = id
		self.created = created
		self.updated = updated
		self.items = items
		self.couponCode = couponCode
		self.deliveryMethod = deliveryMethod
		self.paymentMethod = paymentMethod
		self.buyerProtection = buyerProtection
		self.address = address
		self.availableCouponCodes = availableCouponCodes
		self.totals = totals
	}
}
