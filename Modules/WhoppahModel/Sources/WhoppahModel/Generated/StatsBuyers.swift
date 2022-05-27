//
//  StatsBuyers.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBuyers: Equatable {
	public let averageTimeBetweenOrders: Double

	public init(
		averageTimeBetweenOrders: Double
	) {
		self.averageTimeBetweenOrders = averageTimeBetweenOrders
	}
}
