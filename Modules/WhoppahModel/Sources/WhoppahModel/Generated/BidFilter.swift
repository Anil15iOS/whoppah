//
//  BidFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct BidFilter {
	public let key: BidFilterKey
	public let value: String

	public init(
		key: BidFilterKey,
		value: String
	) {
		self.key = key
		self.value = value
	}
}
