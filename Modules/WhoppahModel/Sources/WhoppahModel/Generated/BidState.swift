//
//  BidState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum BidState: String, CaseIterable {
	case new
	case accepted
	case canceled
	case processing
	case completed
	case expired
	case rejected
	case unknown
}
