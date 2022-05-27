//
//  StatsBySignupDateItemItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsBySignupDateItemItem: Equatable {
	public let transactions: Int
	public let grossmarginvalue: Double

	public init(
		transactions: Int,
		grossmarginvalue: Double
	) {
		self.transactions = transactions
		self.grossmarginvalue = grossmarginvalue
	}
}
