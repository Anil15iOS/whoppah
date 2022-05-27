//
//  Message.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Message: Equatable {
	public let id: UUID
	public let created: Date
	public let updated: Date?
	public let sender: Member
	public let merchant: Merchant
	public let subscriber: Subscriber?
	public let body: String?
	public let unread: Bool

	public init(
		id: UUID,
		created: Date,
		updated: Date? = nil,
		sender: Member,
		merchant: Merchant,
		subscriber: Subscriber? = nil,
		body: String? = nil,
		unread: Bool
	) {
		self.id = id
		self.created = created
		self.updated = updated
		self.sender = sender
		self.merchant = merchant
		self.subscriber = subscriber
		self.body = body
		self.unread = unread
	}
}
