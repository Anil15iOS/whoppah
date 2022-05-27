//
//  Fee.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Fee: Equatable {
	public let type: CalculationMethod
	public let amount: Double

	public init(
		type: CalculationMethod,
		amount: Double
	) {
		self.type = type
		self.amount = amount
	}
}
