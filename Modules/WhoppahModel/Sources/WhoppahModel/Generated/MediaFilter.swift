//
//  MediaFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MediaFilter {
	public let key: MediaFilterKey?
	public let value: String?

	public init(
		key: MediaFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
