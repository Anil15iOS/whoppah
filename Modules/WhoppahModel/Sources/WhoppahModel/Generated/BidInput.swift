//
//  BidInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct BidInput {
	public let auctionId: UUID
	public let amount: PriceInput
	public let createThread: Bool?

	public init(
		auctionId: UUID,
		amount: PriceInput,
		createThread: Bool? = nil
	) {
		self.auctionId = auctionId
		self.amount = amount
		self.createThread = createThread
	}
}
