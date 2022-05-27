//
//  OrderTotals.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct OrderTotals: Equatable {
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

	public init(
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
		totalExclVat: Double
	) {
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
	}
}
