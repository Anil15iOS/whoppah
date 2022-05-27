//
//  Auction.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Auction: Equatable {
	public let id: UUID
	public let identifier: String
	public let state: AuctionState
	public let product: UUID
	public let startDate: Date?
	public let expiryDate: Date?
	public let endDate: Date?
	public let buyNowPrice: Price?
	public let minimumBid: Price?
	public let soldAt: Price?
	public let allowBid: Bool
	public let allowBuyNow: Bool
	public let bidCount: Int
	public let highestBid: UUID?
	public let bids: [Bid]

	public init(
		id: UUID,
		identifier: String,
		state: AuctionState,
		product: UUID,
		startDate: Date? = nil,
		expiryDate: Date? = nil,
		endDate: Date? = nil,
		buyNowPrice: Price? = nil,
		minimumBid: Price? = nil,
		soldAt: Price? = nil,
		allowBid: Bool,
		allowBuyNow: Bool,
		bidCount: Int,
		highestBid: UUID? = nil,
		bids: [Bid]
	) {
		self.id = id
		self.identifier = identifier
		self.state = state
		self.product = product
		self.startDate = startDate
		self.expiryDate = expiryDate
		self.endDate = endDate
		self.buyNowPrice = buyNowPrice
		self.minimumBid = minimumBid
		self.soldAt = soldAt
		self.allowBid = allowBid
		self.allowBuyNow = allowBuyNow
		self.bidCount = bidCount
		self.highestBid = highestBid
		self.bids = bids
	}
}
