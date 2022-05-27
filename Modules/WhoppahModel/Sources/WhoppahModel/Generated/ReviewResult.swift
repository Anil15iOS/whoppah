//
//  ReviewResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ReviewResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Review]

	public init(
		pagination: PaginationResult,
		items: [Review]
	) {
		self.pagination = pagination
		self.items = items
	}
}
