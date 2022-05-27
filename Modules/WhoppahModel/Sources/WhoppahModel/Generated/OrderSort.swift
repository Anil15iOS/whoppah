//
//  OrderSort.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum OrderSort: String, CaseIterable {
	case `default`
	case created
	case expiryDate
	case endDate
	case payout
	case productTitle
	case totalInclVat
	case unknown
}
