//
//  AddToCartInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AddToCartInput {
	public let type: CartItemType
	public let objectId: UUID
	public let serviceType: ServiceType?

	public init(
		type: CartItemType,
		objectId: UUID,
		serviceType: ServiceType? = nil
	) {
		self.type = type
		self.objectId = objectId
		self.serviceType = serviceType
	}
}
