//
//  CategoryFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CategoryFilter {
	public let key: CategoryFilterKey
	public let value: String

	public init(
		key: CategoryFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
