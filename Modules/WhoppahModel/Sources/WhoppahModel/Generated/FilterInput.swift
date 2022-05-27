//
//  FilterInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct FilterInput {
	public let key: SearchFilterKey?
	public let value: String?

	public init(
		key: SearchFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
