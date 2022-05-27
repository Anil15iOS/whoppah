//
//  CartItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CartItem: Equatable {
	public let id: UUID
	public let product: Product
	public let bid: Bid?
	public let serviceType: ServiceType?

	public init(
		id: UUID,
		product: Product,
		bid: Bid? = nil,
		serviceType: ServiceType? = nil
	) {
		self.id = id
		self.product = product
		self.bid = bid
		self.serviceType = serviceType
	}
}
