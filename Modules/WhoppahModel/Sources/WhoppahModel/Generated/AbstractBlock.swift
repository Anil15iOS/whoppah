//
//  AbstractBlock.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public protocol AbstractBlock {
	var id: UUID { get }
	var title: String { get }
	var slug: String { get }
	var summary: String? { get }
	var link: String? { get }
	var location: BlockLocation? { get }
}
