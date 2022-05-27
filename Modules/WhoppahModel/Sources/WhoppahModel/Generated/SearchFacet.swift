//
//  SearchFacet.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct SearchFacet: Equatable & Hashable {
	public let key: SearchFacetKey?
	public let values: [SearchFacetValue]?

	public init(
		key: SearchFacetKey? = nil,
		values: [SearchFacetValue]? = nil
	) {
		self.key = key
		self.values = values
	}
}
