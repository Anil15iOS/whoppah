//
//  MerchantPayment.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantPayment: Node & Equatable {
	public let id: UUID
	public let created: Date
	public let updated: Date
	public let amount: Price
	public let destination: String

	public init(
		id: UUID,
		created: Date,
		updated: Date,
		amount: Price,
		destination: String
	) {
		self.id = id
		self.created = created
		self.updated = updated
		self.amount = amount
		self.destination = destination
	}
}
