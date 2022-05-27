//
//  MerchantResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Merchant]

	public init(
		pagination: PaginationResult,
		items: [Merchant]
	) {
		self.pagination = pagination
		self.items = items
	}
}
