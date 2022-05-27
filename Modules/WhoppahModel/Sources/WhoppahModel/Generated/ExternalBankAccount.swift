//
//  ExternalBankAccount.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ExternalBankAccount: Equatable {
	public let id: String
	public let currency: Currency
	public let accountHolderName: String?
	public let bankName: String
	public let last4: String

	public init(
		id: String,
		currency: Currency,
		accountHolderName: String? = nil,
		bankName: String,
		last4: String
	) {
		self.id = id
		self.currency = currency
		self.accountHolderName = accountHolderName
		self.bankName = bankName
		self.last4 = last4
	}
}
