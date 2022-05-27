//
//  PageResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PageResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Page]

	public init(
		pagination: PaginationResult,
		items: [Page]
	) {
		self.pagination = pagination
		self.items = items
	}
}
