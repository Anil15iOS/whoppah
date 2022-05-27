//
//  AuctionInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AuctionInput {
	public let productId: UUID
	public let currency: Currency
	public let buyNowPrice: PriceInput?
	public let minimumBid: PriceInput?
	public let allowBid: Bool
	public let allowBuyNow: Bool

	public init(
		productId: UUID,
		currency: Currency,
		buyNowPrice: PriceInput? = nil,
		minimumBid: PriceInput? = nil,
		allowBid: Bool,
		allowBuyNow: Bool
	) {
		self.productId = productId
		self.currency = currency
		self.buyNowPrice = buyNowPrice
		self.minimumBid = minimumBid
		self.allowBid = allowBid
		self.allowBuyNow = allowBuyNow
	}
}
