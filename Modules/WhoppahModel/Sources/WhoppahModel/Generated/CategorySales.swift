//
//  CategorySales.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CategorySales: Equatable {
	public let title: String
	public let salesVolume: Double

	public init(
		title: String,
		salesVolume: Double
	) {
		self.title = title
		self.salesVolume = salesVolume
	}
}
