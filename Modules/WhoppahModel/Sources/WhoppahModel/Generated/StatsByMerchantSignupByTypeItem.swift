//
//  StatsByMerchantSignupByTypeItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByMerchantSignupByTypeItem: Equatable {
	public let signupMonth: String
	public let orderQuarter: String
	public let userCount: Int
	public let transactionsCount: Int
	public let grossSalesVolume: Double
	public let totalSalesCommission: Double
	public let totalSalesCourier: Double

	public init(
		signupMonth: String,
		orderQuarter: String,
		userCount: Int,
		transactionsCount: Int,
		grossSalesVolume: Double,
		totalSalesCommission: Double,
		totalSalesCourier: Double
	) {
		self.signupMonth = signupMonth
		self.orderQuarter = orderQuarter
		self.userCount = userCount
		self.transactionsCount = transactionsCount
		self.grossSalesVolume = grossSalesVolume
		self.totalSalesCommission = totalSalesCommission
		self.totalSalesCourier = totalSalesCourier
	}
}
