//
//  BlockLocation.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum BlockLocation: String, CaseIterable {
	case header
	case footer
	case body
	case asideLeft
	case asideRight
	case unknown
}
