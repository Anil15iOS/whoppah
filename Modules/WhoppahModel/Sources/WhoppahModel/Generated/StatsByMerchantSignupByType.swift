//
//  StatsByMerchantSignupByType.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByMerchantSignupByType: Equatable {
	public let total: [StatsByMerchantSignupByTypeItem]
	public let individual: [StatsByMerchantSignupByTypeItem]
	public let business: [StatsByMerchantSignupByTypeItem]

	public init(
		total: [StatsByMerchantSignupByTypeItem],
		individual: [StatsByMerchantSignupByTypeItem],
		business: [StatsByMerchantSignupByTypeItem]
	) {
		self.total = total
		self.individual = individual
		self.business = business
	}
}
