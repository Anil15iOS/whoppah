//
//  OrderState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum OrderState: String, CaseIterable {
	case new
	case canceled
	case expired
	case accepted
	case shipped
	case disputed
	case completed
	case delivered
	case unknown
}
