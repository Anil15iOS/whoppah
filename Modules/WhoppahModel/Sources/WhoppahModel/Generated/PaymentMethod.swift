//
//  PaymentMethod.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum PaymentMethod: String, CaseIterable {
	case card
	case bancontact
	case ideal
	case klarna
	case unknown
}
