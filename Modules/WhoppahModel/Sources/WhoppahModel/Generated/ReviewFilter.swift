//
//  ReviewFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ReviewFilter {
	public let key: ReviewFilterKey
	public let value: String

	public init(
		key: ReviewFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
