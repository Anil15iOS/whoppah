//
//  StatsFavoritesByProductState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsFavoritesByProductState: Equatable {
	public let activeAds: StatsFavoritesByProductStateItem
	public let soldAds: StatsFavoritesByProductStateItem
	public let allAds: StatsFavoritesByProductStateItem

	public init(
		activeAds: StatsFavoritesByProductStateItem,
		soldAds: StatsFavoritesByProductStateItem,
		allAds: StatsFavoritesByProductStateItem
	) {
		self.activeAds = activeAds
		self.soldAds = soldAds
		self.allAds = allAds
	}
}
