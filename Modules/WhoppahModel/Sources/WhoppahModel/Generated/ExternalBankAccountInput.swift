//
//  ExternalBankAccountInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ExternalBankAccountInput {
	public let accountHolderName: String
	public let accountNumber: String

	public init(
		accountHolderName: String,
		accountNumber: String
	) {
		self.accountHolderName = accountHolderName
		self.accountNumber = accountNumber
	}
}
