//
//  Node.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public protocol Node {
	var id: UUID { get }
	var created: Date { get }
	var updated: Date { get }
}
