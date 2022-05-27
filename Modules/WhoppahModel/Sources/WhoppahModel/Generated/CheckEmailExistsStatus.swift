//
//  CheckEmailExistsStatus.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum CheckEmailExistsStatus: String, CaseIterable {
	case available
	case unavailable
	case banned
	case unknown
}
