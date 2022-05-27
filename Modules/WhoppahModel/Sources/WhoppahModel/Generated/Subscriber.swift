//
//  Subscriber.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Subscriber: Equatable {
	public let id: UUID
	public let merchant: Merchant
	public let role: SubscriberRole

	public init(
		id: UUID,
		merchant: Merchant,
		role: SubscriberRole
	) {
		self.id = id
		self.merchant = merchant
		self.role = role
	}
}
