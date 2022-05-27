//
//  OrderFilterKey.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum OrderFilterKey: String, CaseIterable {
	case merchant
	case buyer
	case product
	case auction
	case bid
	case deliveryMethod
	case shippingMethod
	case state
	case productTitle
	case bidState
	case unknown
}
