//
//  ThreadFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ThreadFilter {
	public let key: ThreadFilterKey?
	public let value: String?

	public init(
		key: ThreadFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
