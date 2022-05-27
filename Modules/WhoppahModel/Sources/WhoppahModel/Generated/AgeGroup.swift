//
//  AgeGroup.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AgeGroup: Equatable {
	public let count: Int
	public let group: String

	public init(
		count: Int,
		group: String
	) {
		self.count = count
		self.group = group
	}
}
