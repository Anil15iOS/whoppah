//
//  OrderFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct OrderFilter {
	public let key: OrderFilterKey
	public let value: String

	public init(
		key: OrderFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
