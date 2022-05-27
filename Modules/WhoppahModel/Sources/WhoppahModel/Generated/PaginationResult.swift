//
//  PaginationResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct PaginationResult: Equatable {
	public let page: Int
	public let pages: Int
	public let limit: Int
	public let count: Int

	public init(
		page: Int,
		pages: Int,
		limit: Int,
		count: Int
	) {
		self.page = page
		self.pages = pages
		self.limit = limit
		self.count = count
	}
}
