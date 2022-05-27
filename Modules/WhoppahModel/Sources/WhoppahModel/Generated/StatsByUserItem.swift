//
//  StatsByUserItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByUserItem: Equatable {
	public let transactions: Int
	public let favorites: Int
	public let listings: Int
	public let bids: Int

	public init(
		transactions: Int,
		favorites: Int,
		listings: Int,
		bids: Int
	) {
		self.transactions = transactions
		self.favorites = favorites
		self.listings = listings
		self.bids = bids
	}
}
