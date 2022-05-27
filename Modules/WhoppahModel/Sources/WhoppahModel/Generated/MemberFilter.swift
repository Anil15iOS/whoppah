//
//  MemberFilter.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MemberFilter {
	public let key: MemberFilterKey?
	public let value: String?

	public init(
		key: MemberFilterKey? = nil,
		value: String? = nil
	) {
		self.key = key
		self.value = value
	}
}
