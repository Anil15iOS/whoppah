//
//  StatsMerchants.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsMerchants: Equatable {
	public let individual: StatsMerchant
	public let business: StatsMerchant
	public let total: StatsMerchant

	public init(
		individual: StatsMerchant,
		business: StatsMerchant,
		total: StatsMerchant
	) {
		self.individual = individual
		self.business = business
		self.total = total
	}
}
