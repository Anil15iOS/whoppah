//
//  CategoryResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CategoryResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Category]

	public init(
		pagination: PaginationResult,
		items: [Category]
	) {
		self.pagination = pagination
		self.items = items
	}
}
