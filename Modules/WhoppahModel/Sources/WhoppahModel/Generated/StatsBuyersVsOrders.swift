//
//  StatsBuyersVsOrders.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBuyersVsOrders: Equatable {
	public let total: [StatsBuyersVsOrdersItem]
	public let byordercount: [StatsBuyersVsOrdersItem]

	public init(
		total: [StatsBuyersVsOrdersItem],
		byordercount: [StatsBuyersVsOrdersItem]
	) {
		self.total = total
		self.byordercount = byordercount
	}
}
