//
//  MediaState.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public enum MediaState: String, CaseIterable {
	case uploading
	case uploaded
	case processing
	case processed
	case unknown
}
