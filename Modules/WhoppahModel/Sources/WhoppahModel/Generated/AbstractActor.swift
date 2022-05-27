//
//  AbstractActor.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public protocol AbstractActor {
	var id: UUID { get }
	var countryOfOrigin: String? { get }
}
