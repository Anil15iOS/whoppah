//
//  SearchFilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchFilterInput {
	public let attributes: [AttributeSearchFilterInput]
	public let properties: [PropertySearchFilterInput]
	public let categories: CategorySearchFilterInput?
	public let price: PriceSearchFilterInput?
	public let inShowroom: Bool?
	public let location: LocationSearchFilterInput?

	public init(
		attributes: [AttributeSearchFilterInput],
		properties: [PropertySearchFilterInput],
		categories: CategorySearchFilterInput? = nil,
		price: PriceSearchFilterInput? = nil,
		inShowroom: Bool? = nil,
		location: LocationSearchFilterInput? = nil
	) {
		self.attributes = attributes
		self.properties = properties
		self.categories = categories
		self.price = price
		self.inShowroom = inShowroom
		self.location = location
	}
}
