//
//  CurationReason.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CurationReason: Equatable {
	public let message: String?
	public let reason: String?

	public init(
		message: String? = nil,
		reason: String? = nil
	) {
		self.message = message
		self.reason = reason
	}
}
