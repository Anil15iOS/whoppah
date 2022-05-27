//
//  CategorySearchFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CategorySearchFilter: Equatable {
	public let items: [Category]

	public init(
		items: [Category]
	) {
		self.items = items
	}
}
