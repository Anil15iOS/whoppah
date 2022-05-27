//
//  StatsFavorites.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsFavorites: Equatable {
	public let monthly: [StatsFavoriteMonthly]
	public let quarterly: [StatsFavoriteQuarterly]

	public init(
		monthly: [StatsFavoriteMonthly],
		quarterly: [StatsFavoriteQuarterly]
	) {
		self.monthly = monthly
		self.quarterly = quarterly
	}
}
