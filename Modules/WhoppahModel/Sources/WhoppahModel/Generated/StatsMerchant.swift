//
//  StatsMerchant.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsMerchant: Equatable {
	public let totalAdsActive: Int
	public let totalAdsSold: Int
	public let totalAdsCanceled: Int
	public let totalAdsBanned: Int
	public let totalAdsCreated: Int
	public let averageAdsCanceled: Double
	public let averageAdsActive: Double
	public let averageAdsSold: Double
	public let averageAdsBanned: Double
	public let averageAdsCreated: Double
	public let averageSoldAfter: Double
	public let averageSoldPercentage: Double

	public init(
		totalAdsActive: Int,
		totalAdsSold: Int,
		totalAdsCanceled: Int,
		totalAdsBanned: Int,
		totalAdsCreated: Int,
		averageAdsCanceled: Double,
		averageAdsActive: Double,
		averageAdsSold: Double,
		averageAdsBanned: Double,
		averageAdsCreated: Double,
		averageSoldAfter: Double,
		averageSoldPercentage: Double
	) {
		self.totalAdsActive = totalAdsActive
		self.totalAdsSold = totalAdsSold
		self.totalAdsCanceled = totalAdsCanceled
		self.totalAdsBanned = totalAdsBanned
		self.totalAdsCreated = totalAdsCreated
		self.averageAdsCanceled = averageAdsCanceled
		self.averageAdsActive = averageAdsActive
		self.averageAdsSold = averageAdsSold
		self.averageAdsBanned = averageAdsBanned
		self.averageAdsCreated = averageAdsCreated
		self.averageSoldAfter = averageSoldAfter
		self.averageSoldPercentage = averageSoldPercentage
	}
}
