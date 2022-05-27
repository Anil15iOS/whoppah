//
//  StatsByUser.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByUser: Equatable {
	public let id: UUID
	public let last6Months: StatsByUserItem
	public let last12Months: StatsByUserItem
	public let last18Months: StatsByUserItem

	public init(
		id: UUID,
		last6Months: StatsByUserItem,
		last12Months: StatsByUserItem,
		last18Months: StatsByUserItem
	) {
		self.id = id
		self.last6Months = last6Months
		self.last12Months = last12Months
		self.last18Months = last18Months
	}
}
