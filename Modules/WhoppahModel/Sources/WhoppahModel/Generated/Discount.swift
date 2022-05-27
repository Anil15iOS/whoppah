//
//  Discount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Discount: Equatable {
	public let type: CalculationMethod
	public let amount: Double?

	public init(
		type: CalculationMethod,
		amount: Double? = nil
	) {
		self.type = type
		self.amount = amount
	}
}
