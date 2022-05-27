//
//  CounterBidInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CounterBidInput {
	public let auctionId: UUID
	public let amount: PriceInput
	public let buyerId: UUID

	public init(
		auctionId: UUID,
		amount: PriceInput,
		buyerId: UUID
	) {
		self.auctionId = auctionId
		self.amount = amount
		self.buyerId = buyerId
	}
}
