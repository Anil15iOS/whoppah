//
//  StatsSellers.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsSellers: Equatable {
	public let ageGroups: [AgeGroup]

	public init(
		ageGroups: [AgeGroup]
	) {
		self.ageGroups = ageGroups
	}
}
