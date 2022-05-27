//
//  SearchSort.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum SearchSort: String, CaseIterable {
	case `default`
	case distance
	case price
	case created
	case title
	case popularity
	case unknown
}
