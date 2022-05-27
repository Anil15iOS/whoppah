//
//  StatsByQuarter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByQuarter: Equatable {
	public let quarter: String
	public let totalTransactions: Int
	public let totalTransactionsShowroom: Int
	public let courierShippingCountShowroom: Int
	public let courierShippingAmountShowroom: Double
	public let courierShippingCount: Int
	public let registeredShippingCount: Int
	public let standardShippingCount: Int
	public let customShippingCount: Int
	public let courierShippingAmount: Double
	public let registeredShippingAmount: Double
	public let standardShippingAmount: Double
	public let customShippingAmount: Double
	public let pickupCount: Int
	public let pickupCountShowroom: Int
	public let totalTransactionFees: Double
	public let totalGrossSalesVolume: Double
	public let nonServicesGrossSalesVolume: Double
	public let servicesTransactions: Int
	public let nonServicesTransactions: Int
	public let servicesGrossSalesVolume: Double
	public let totalSalesCommission: Double
	public let totalSalesCourier: Double
	public let totalGrossSalesMargin: Double
	public let averageOrderValue: Double
	public let promoPackageCount: Int
	public let promoPackageAmount: Double

	public init(
		quarter: String,
		totalTransactions: Int,
		totalTransactionsShowroom: Int,
		courierShippingCountShowroom: Int,
		courierShippingAmountShowroom: Double,
		courierShippingCount: Int,
		registeredShippingCount: Int,
		standardShippingCount: Int,
		customShippingCount: Int,
		courierShippingAmount: Double,
		registeredShippingAmount: Double,
		standardShippingAmount: Double,
		customShippingAmount: Double,
		pickupCount: Int,
		pickupCountShowroom: Int,
		totalTransactionFees: Double,
		totalGrossSalesVolume: Double,
		nonServicesGrossSalesVolume: Double,
		servicesTransactions: Int,
		nonServicesTransactions: Int,
		servicesGrossSalesVolume: Double,
		totalSalesCommission: Double,
		totalSalesCourier: Double,
		totalGrossSalesMargin: Double,
		averageOrderValue: Double,
		promoPackageCount: Int,
		promoPackageAmount: Double
	) {
		self.quarter = quarter
		self.totalTransactions = totalTransactions
		self.totalTransactionsShowroom = totalTransactionsShowroom
		self.courierShippingCountShowroom = courierShippingCountShowroom
		self.courierShippingAmountShowroom = courierShippingAmountShowroom
		self.courierShippingCount = courierShippingCount
		self.registeredShippingCount = registeredShippingCount
		self.standardShippingCount = standardShippingCount
		self.customShippingCount = customShippingCount
		self.courierShippingAmount = courierShippingAmount
		self.registeredShippingAmount = registeredShippingAmount
		self.standardShippingAmount = standardShippingAmount
		self.customShippingAmount = customShippingAmount
		self.pickupCount = pickupCount
		self.pickupCountShowroom = pickupCountShowroom
		self.totalTransactionFees = totalTransactionFees
		self.totalGrossSalesVolume = totalGrossSalesVolume
		self.nonServicesGrossSalesVolume = nonServicesGrossSalesVolume
		self.servicesTransactions = servicesTransactions
		self.nonServicesTransactions = nonServicesTransactions
		self.servicesGrossSalesVolume = servicesGrossSalesVolume
		self.totalSalesCommission = totalSalesCommission
		self.totalSalesCourier = totalSalesCourier
		self.totalGrossSalesMargin = totalGrossSalesMargin
		self.averageOrderValue = averageOrderValue
		self.promoPackageCount = promoPackageCount
		self.promoPackageAmount = promoPackageAmount
	}
}
