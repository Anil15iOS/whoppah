//
//  ProductState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum ProductState: String, CaseIterable {
	case draft
	case curation
	case rejected
	case banned
	case canceled
	case accepted
	case updated
	case archive
	case unknown
}
