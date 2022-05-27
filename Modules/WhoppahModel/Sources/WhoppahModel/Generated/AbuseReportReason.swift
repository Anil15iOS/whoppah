//
//  AbuseReportReason.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum AbuseReportReason: String, CaseIterable {
	case violatingContent
	case spam
	case wrongCategory
	case poorPhotoQuality
	case unknown
}
