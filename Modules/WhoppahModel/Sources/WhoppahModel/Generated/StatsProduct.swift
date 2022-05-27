//
//  StatsProduct.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsProduct: Equatable {
	public let individual: StatsProductItem
	public let business: StatsProductItem
	public let total: StatsProductItem

	public init(
		individual: StatsProductItem,
		business: StatsProductItem,
		total: StatsProductItem
	) {
		self.individual = individual
		self.business = business
		self.total = total
	}
}
