//
//  BankAccountInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct BankAccountInput {
	public let accountNumber: String
	public let routingNumber: String?
	public let accountHolderName: String

	public init(
		accountNumber: String,
		routingNumber: String? = nil,
		accountHolderName: String
	) {
		self.accountNumber = accountNumber
		self.routingNumber = routingNumber
		self.accountHolderName = accountHolderName
	}
}
