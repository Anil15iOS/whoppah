//
//  StripeAccount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StripeAccount: Equatable {
	public let accountId: String
	public let verified: Bool

	public init(
		accountId: String,
		verified: Bool
	) {
		self.accountId = accountId
		self.verified = verified
	}
}
