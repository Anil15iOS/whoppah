//
//  Subscription.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Subscription: Equatable {
	public let status: Int?

	public init(
		status: Int? = nil
	) {
		self.status = status
	}
}
