//
//  MemberResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MemberResult: Equatable {
	public let pagination: PaginationResult
	public let items: [Member]

	public init(
		pagination: PaginationResult,
		items: [Member]
	) {
		self.pagination = pagination
		self.items = items
	}
}
