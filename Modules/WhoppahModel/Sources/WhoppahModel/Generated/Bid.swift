//
//  Bid.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Bid: Equatable {
	public let id: UUID
	public let auction: UUID
	public let buyer: UUID
	public let merchant: UUID
	public let state: BidState
	public let order: UUID?
	public let created: Date
	public let expiryDate: Date
	public let endDate: Date?
	public let amount: Price
	public let isCounter: Bool
	public let thread: UUID?

	public init(
		id: UUID,
		auction: UUID,
		buyer: UUID,
		merchant: UUID,
		state: BidState,
		order: UUID? = nil,
		created: Date,
		expiryDate: Date,
		endDate: Date? = nil,
		amount: Price,
		isCounter: Bool,
		thread: UUID? = nil
	) {
		self.id = id
		self.auction = auction
		self.buyer = buyer
		self.merchant = merchant
		self.state = state
		self.order = order
		self.created = created
		self.expiryDate = expiryDate
		self.endDate = endDate
		self.amount = amount
		self.isCounter = isCounter
		self.thread = thread
	}
}
