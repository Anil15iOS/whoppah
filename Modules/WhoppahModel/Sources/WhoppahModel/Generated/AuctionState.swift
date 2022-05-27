//
//  AuctionState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum AuctionState: String, CaseIterable {
	case draft
	case published
	case canceled
	case expired
	case reserved
	case completed
	case banned
	case unknown
}
