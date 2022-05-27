//
//  MerchantRequirement.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum MerchantRequirement: String, CaseIterable {
	case identifyDocument
	case ownerDocument
	case address
	case email
	case givenName
	case familyName
	case dateOfBirth
	case taxId
	case vatId
	case unknown
}
