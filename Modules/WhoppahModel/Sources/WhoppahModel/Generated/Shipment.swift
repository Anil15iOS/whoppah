//
//  Shipment.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Shipment: Equatable {
	public let id: UUID
	public let created: Date
	public let updated: Date?
	public let order: Order
	public let merchant: Merchant
	public let trackingCode: String?
	public let returnCode: String?

	public init(
		id: UUID,
		created: Date,
		updated: Date? = nil,
		order: Order,
		merchant: Merchant,
		trackingCode: String? = nil,
		returnCode: String? = nil
	) {
		self.id = id
		self.created = created
		self.updated = updated
		self.order = order
		self.merchant = merchant
		self.trackingCode = trackingCode
		self.returnCode = returnCode
	}
}
