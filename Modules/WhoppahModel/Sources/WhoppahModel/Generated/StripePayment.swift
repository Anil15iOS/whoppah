//
//  StripePayment.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StripePayment: Equatable {
	public let paymentMethod: String
	public let paymentMethodId: String?
	public let paymentSourceId: String?
	public let paymentIntentId: String?
	public let clientSecretId: String

	public init(
		paymentMethod: String,
		paymentMethodId: String? = nil,
		paymentSourceId: String? = nil,
		paymentIntentId: String? = nil,
		clientSecretId: String
	) {
		self.paymentMethod = paymentMethod
		self.paymentMethodId = paymentMethodId
		self.paymentSourceId = paymentSourceId
		self.paymentIntentId = paymentIntentId
		self.clientSecretId = clientSecretId
	}
}
