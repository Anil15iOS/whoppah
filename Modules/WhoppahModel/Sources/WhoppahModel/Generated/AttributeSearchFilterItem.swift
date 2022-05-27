//
//  AttributeSearchFilterItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AttributeSearchFilterItem: Equatable {
	public let key: String
	public let value: String
	public let count: Int
	public let items: [AttributeSearchFilterItem]

	public init(
		key: String,
		value: String,
		count: Int,
		items: [AttributeSearchFilterItem]
	) {
		self.key = key
		self.value = value
		self.count = count
		self.items = items
	}
}
