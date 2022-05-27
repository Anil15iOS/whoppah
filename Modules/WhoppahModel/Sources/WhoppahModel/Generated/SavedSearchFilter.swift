//
//  SavedSearchFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SavedSearchFilter {
	public let key: SavedSearchFilterKey
	public let value: String

	public init(
		key: SavedSearchFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
