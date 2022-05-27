//
//  ProductFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ProductFilter {
	public let key: ProductFilterKey
	public let value: String

	public init(
		key: ProductFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
