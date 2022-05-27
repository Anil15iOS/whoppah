//
//  ProductResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ProductResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Product]

	public init(
		pagination: PaginationResult,
		items: [Product]
	) {
		self.pagination = pagination
		self.items = items
	}
}
