//
//  CheckEmailExistsResponse.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct CheckEmailExistsResponse: Equatable {
	public let status: CheckEmailExistsStatus?

	public init(
		status: CheckEmailExistsStatus? = nil
	) {
		self.status = status
	}
}
