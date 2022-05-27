//
//  SearchFacetValue.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchFacetValue: Equatable & Hashable {
	public let value: String?
	public let count: Int?
	public let category: UUID?
	public let merchant: UUID?

	public init(
		value: String? = nil,
		count: Int? = nil,
		category: UUID? = nil,
		merchant: UUID? = nil
	) {
		self.value = value
		self.count = count
		self.category = category
		self.merchant = merchant
	}
}
