//
//  MessageResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MessageResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Message]

	public init(
		pagination: PaginationResult,
		items: [Message]
	) {
		self.pagination = pagination
		self.items = items
	}
}
