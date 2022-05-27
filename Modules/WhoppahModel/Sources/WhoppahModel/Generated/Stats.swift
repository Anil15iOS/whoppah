//
//  Stats.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Stats: Equatable {
	public let totalTransactions: Int
	public let totalTransactionFees: Double
	public let totalGrossSalesVolume: Double
	public let totalSalesCommission: Double
	public let totalSalesCourier: Double
	public let totalGrossSalesMargin: Double
	public let totalGrossSalesVolumeIndividual: Double
	public let totalGrossSalesVolumeBusiness: Double
	public let avgOrderValue: Double
	public let avgOrderValueIndividual: Double
	public let avgOrderValueBusiness: Double
	public let totalBids: Int
	public let buyerCountVsOrderCount: [BuyerCountVsOrderCount]
	public let sellerCountVsOrderCount: [SellerCountVsOrderCount]
	public let merchantCountVsProductCount: [MerchantCountVsProductCount]
	public let merchantCountVsChatCount: [MerchantCountVsChatCount]
	public let individualMerchantsCount: Int
	public let businessMerchantsCount: Int
	public let individualProductsCount: Int
	public let businessProductsCount: Int
	public let uniqueAdCreatorsCount: Int
	public let recurringAdCreatorsCount: Int
	public let totalThreads: Int
	public let uniqueThreadsByMerchantsCount: Int
	public let recurringThreadsByMerchants: Int
	public let salesByCategory: [CategorySales]

	public init(
		totalTransactions: Int,
		totalTransactionFees: Double,
		totalGrossSalesVolume: Double,
		totalSalesCommission: Double,
		totalSalesCourier: Double,
		totalGrossSalesMargin: Double,
		totalGrossSalesVolumeIndividual: Double,
		totalGrossSalesVolumeBusiness: Double,
		avgOrderValue: Double,
		avgOrderValueIndividual: Double,
		avgOrderValueBusiness: Double,
		totalBids: Int,
		buyerCountVsOrderCount: [BuyerCountVsOrderCount],
		sellerCountVsOrderCount: [SellerCountVsOrderCount],
		merchantCountVsProductCount: [MerchantCountVsProductCount],
		merchantCountVsChatCount: [MerchantCountVsChatCount],
		individualMerchantsCount: Int,
		businessMerchantsCount: Int,
		individualProductsCount: Int,
		businessProductsCount: Int,
		uniqueAdCreatorsCount: Int,
		recurringAdCreatorsCount: Int,
		totalThreads: Int,
		uniqueThreadsByMerchantsCount: Int,
		recurringThreadsByMerchants: Int,
		salesByCategory: [CategorySales]
	) {
		self.totalTransactions = totalTransactions
		self.totalTransactionFees = totalTransactionFees
		self.totalGrossSalesVolume = totalGrossSalesVolume
		self.totalSalesCommission = totalSalesCommission
		self.totalSalesCourier = totalSalesCourier
		self.totalGrossSalesMargin = totalGrossSalesMargin
		self.totalGrossSalesVolumeIndividual = totalGrossSalesVolumeIndividual
		self.totalGrossSalesVolumeBusiness = totalGrossSalesVolumeBusiness
		self.avgOrderValue = avgOrderValue
		self.avgOrderValueIndividual = avgOrderValueIndividual
		self.avgOrderValueBusiness = avgOrderValueBusiness
		self.totalBids = totalBids
		self.buyerCountVsOrderCount = buyerCountVsOrderCount
		self.sellerCountVsOrderCount = sellerCountVsOrderCount
		self.merchantCountVsProductCount = merchantCountVsProductCount
		self.merchantCountVsChatCount = merchantCountVsChatCount
		self.individualMerchantsCount = individualMerchantsCount
		self.businessMerchantsCount = businessMerchantsCount
		self.individualProductsCount = individualProductsCount
		self.businessProductsCount = businessProductsCount
		self.uniqueAdCreatorsCount = uniqueAdCreatorsCount
		self.recurringAdCreatorsCount = recurringAdCreatorsCount
		self.totalThreads = totalThreads
		self.uniqueThreadsByMerchantsCount = uniqueThreadsByMerchantsCount
		self.recurringThreadsByMerchants = recurringThreadsByMerchants
		self.salesByCategory = salesByCategory
	}
}
