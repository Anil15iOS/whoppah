//
//  StatsByMerchantSignup.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByMerchantSignup: Equatable {
	public let buyers: StatsByMerchantSignupByType
	public let sellers: StatsByMerchantSignupByType
	public let buyersandsellers: StatsByMerchantSignupByType

	public init(
		buyers: StatsByMerchantSignupByType,
		sellers: StatsByMerchantSignupByType,
		buyersandsellers: StatsByMerchantSignupByType
	) {
		self.buyers = buyers
		self.sellers = sellers
		self.buyersandsellers = buyersandsellers
	}
}
