//
//  Pagination.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Pagination {
	public var page: Int = 1
	public var limit: Int = 25

	public init(
		page: Int = 1,
		limit: Int = 25
	) {
		self.page = page
		self.limit = limit
	}
}
