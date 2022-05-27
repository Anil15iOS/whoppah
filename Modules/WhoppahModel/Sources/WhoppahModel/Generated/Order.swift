//
//  Order.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Order: Equatable {
	public let id: UUID
	public let merchant: Merchant
	public let buyer: Merchant
	public let address: OrderAddress?
	public let product: Product
	public let auction: Auction
	public let bid: Bid?
	public let currency: Currency
	public let purchaseType: PurchaseType
	public let thread: Thread?
	public let review: UUID?
	public let deliveryMethod: DeliveryMethod
	public let deliveryFeedback: String?
	public let shippingMethod: ShippingMethod?
	public let shipment: UUID?
	public let serviceTarget: Product?
	public let state: OrderState
	public let created: Date?
	public let expiryDate: Date
	public let endDate: Date?
	public let subtotalInclVat: Double
	public let subtotalExclVat: Double
	public let shippingInclVat: Double
	public let shippingExclVat: Double
	public let serviceCostInclVat: Double
	public let serviceCostExclVat: Double
	public let creditCardCostInclVat: Double
	public let creditCardCostExclVat: Double
	public let buyerProtectionInclVat: Double
	public let buyerProtectionExclVat: Double
	public let discountInclVat: Double
	public let discountExclVat: Double
	public let totalInclVat: Double
	public let totalExclVat: Double
	public let feeInclVat: Double
	public let feeExclVat: Double
	public let payout: Double
	public let payoutEta: Date?
	public let payment: StripePayment?
	public let payoutStatus: String?
	public let paymentStatus: String?
	public let buyerReceipt: String?
	public let sellerReceipt: String?

	public init(
		id: UUID,
		merchant: Merchant,
		buyer: Merchant,
		address: OrderAddress? = nil,
		product: Product,
		auction: Auction,
		bid: Bid? = nil,
		currency: Currency,
		purchaseType: PurchaseType,
		thread: Thread? = nil,
		review: UUID? = nil,
		deliveryMethod: DeliveryMethod,
		deliveryFeedback: String? = nil,
		shippingMethod: ShippingMethod? = nil,
		shipment: UUID? = nil,
		serviceTarget: Product? = nil,
		state: OrderState,
		created: Date? = nil,
		expiryDate: Date,
		endDate: Date? = nil,
		subtotalInclVat: Double,
		subtotalExclVat: Double,
		shippingInclVat: Double,
		shippingExclVat: Double,
		serviceCostInclVat: Double,
		serviceCostExclVat: Double,
		creditCardCostInclVat: Double,
		creditCardCostExclVat: Double,
		buyerProtectionInclVat: Double,
		buyerProtectionExclVat: Double,
		discountInclVat: Double,
		discountExclVat: Double,
		totalInclVat: Double,
		totalExclVat: Double,
		feeInclVat: Double,
		feeExclVat: Double,
		payout: Double,
		payoutEta: Date? = nil,
		payment: StripePayment? = nil,
		payoutStatus: String? = nil,
		paymentStatus: String? = nil,
		buyerReceipt: String? = nil,
		sellerReceipt: String? = nil
	) {
		self.id = id
		self.merchant = merchant
		self.buyer = buyer
		self.address = address
		self.product = product
		self.auction = auction
		self.bid = bid
		self.currency = currency
		self.purchaseType = purchaseType
		self.thread = thread
		self.review = review
		self.deliveryMethod = deliveryMethod
		self.deliveryFeedback = deliveryFeedback
		self.shippingMethod = shippingMethod
		self.shipment = shipment
		self.serviceTarget = serviceTarget
		self.state = state
		self.created = created
		self.expiryDate = expiryDate
		self.endDate = endDate
		self.subtotalInclVat = subtotalInclVat
		self.subtotalExclVat = subtotalExclVat
		self.shippingInclVat = shippingInclVat
		self.shippingExclVat = shippingExclVat
		self.serviceCostInclVat = serviceCostInclVat
		self.serviceCostExclVat = serviceCostExclVat
		self.creditCardCostInclVat = creditCardCostInclVat
		self.creditCardCostExclVat = creditCardCostExclVat
		self.buyerProtectionInclVat = buyerProtectionInclVat
		self.buyerProtectionExclVat = buyerProtectionExclVat
		self.discountInclVat = discountInclVat
		self.discountExclVat = discountExclVat
		self.totalInclVat = totalInclVat
		self.totalExclVat = totalExclVat
		self.feeInclVat = feeInclVat
		self.feeExclVat = feeExclVat
		self.payout = payout
		self.payoutEta = payoutEta
		self.payment = payment
		self.payoutStatus = payoutStatus
		self.paymentStatus = paymentStatus
		self.buyerReceipt = buyerReceipt
		self.sellerReceipt = sellerReceipt
	}
}
