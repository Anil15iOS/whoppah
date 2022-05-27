//
//  PageFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PageFilter {
	public let key: AttributeFilterKey?
	public let value: String?

	public init(
		key: AttributeFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
