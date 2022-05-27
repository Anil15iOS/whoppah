//
//  PropertySearchFilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PropertySearchFilterInput {
	public let key: ProductPropertyKey
	public let value: String

	public init(
		key: ProductPropertyKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
