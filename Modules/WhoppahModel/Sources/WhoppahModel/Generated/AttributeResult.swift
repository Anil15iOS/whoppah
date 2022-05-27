//
//  AttributeResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AttributeResult: Equatable {
	public let pagination: PaginationResult

	public init(
		pagination: PaginationResult
	) {
		self.pagination = pagination
	}
}
