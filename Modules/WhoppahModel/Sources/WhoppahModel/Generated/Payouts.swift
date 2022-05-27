//
//  Payouts.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Payouts: Equatable {
	public let enabled: Bool
	public let items: [Payout]

	public init(
		enabled: Bool,
		items: [Payout]
	) {
		self.enabled = enabled
		self.items = items
	}
}
