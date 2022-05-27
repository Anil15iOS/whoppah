//
//  ShippingMethod.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ShippingMethod: Equatable {
	public let id: UUID
	public let title: String
	public let description: String?
	public let slug: String
	public let price: Price

	public init(
		id: UUID,
		title: String,
		description: String? = nil,
		slug: String,
		price: Price
	) {
		self.id = id
		self.title = title
		self.description = description
		self.slug = slug
		self.price = price
	}
}
