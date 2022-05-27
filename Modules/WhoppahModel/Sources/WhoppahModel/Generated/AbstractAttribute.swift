//
//  AbstractAttribute.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public protocol AbstractAttribute {
	var id: UUID { get }
	var title: String { get }
	var description: String? { get }
	var slug: String { get }
}
