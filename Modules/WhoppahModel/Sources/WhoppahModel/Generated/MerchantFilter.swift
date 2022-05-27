//
//  MerchantFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantFilter {
	public let key: MerchantFilterKey?
	public let value: String?

	public init(
		key: MerchantFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
