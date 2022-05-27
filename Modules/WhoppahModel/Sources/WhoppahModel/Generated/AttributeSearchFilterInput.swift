//
//  AttributeSearchFilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AttributeSearchFilterInput {
	public let key: AttributeType
	public let value: [String]

	public init(
		key: AttributeType,
		value: [String]
	) {
		self.key = key
		self.value = value
	}
}
