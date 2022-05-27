//
//  SubcategoriesInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SubcategoriesInput {
	public let brand: String?
	public let category: String?
	public let style: String?

	public init(
		brand: String? = nil,
		category: String? = nil,
		style: String? = nil
	) {
		self.brand = brand
		self.category = category
		self.style = style
	}
}
