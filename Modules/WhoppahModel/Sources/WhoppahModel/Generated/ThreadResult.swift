//
//  ThreadResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ThreadResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Thread]

	public init(
		pagination: PaginationResult,
		items: [Thread]
	) {
		self.pagination = pagination
		self.items = items
	}
}
