//
//  OrderResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct OrderResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Order]

	public init(
		pagination: PaginationResult,
		items: [Order]
	) {
		self.pagination = pagination
		self.items = items
	}
}
