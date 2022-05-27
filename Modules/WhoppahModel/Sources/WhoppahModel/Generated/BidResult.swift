//
//  BidResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct BidResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Bid]

	public init(
		pagination: PaginationResult,
		items: [Bid]
	) {
		self.pagination = pagination
		self.items = items
	}
}
