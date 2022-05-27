//
//  ShipmentInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ShipmentInput {
	public let orderId: UUID
	public let trackingCode: String?
	public let returnCode: String?

	public init(
		orderId: UUID,
		trackingCode: String? = nil,
		returnCode: String? = nil
	) {
		self.orderId = orderId
		self.trackingCode = trackingCode
		self.returnCode = returnCode
	}
}
