//
//  AddReferralCodeResult.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct AddReferralCodeResult: Equatable {
	public let success: Bool

	public init(
		success: Bool
	) {
		self.success = success
	}
}
