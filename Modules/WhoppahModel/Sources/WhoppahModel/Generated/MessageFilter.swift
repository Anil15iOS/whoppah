//
//  MessageFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MessageFilter {
	public let key: MessageFilterKey?
	public let value: String?

	public init(
		key: MessageFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
