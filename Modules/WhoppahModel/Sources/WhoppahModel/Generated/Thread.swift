//
//  Thread.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Thread: Equatable {
	public let id: UUID
	public let created: Date
	public let updated: Date?
	public let startedBy: Merchant
	public let unreadCount: Int
	public let subscribers: [Subscriber]
	public let messages: [Message]

	public init(
		id: UUID,
		created: Date,
		updated: Date? = nil,
		startedBy: Merchant,
		unreadCount: Int,
		subscribers: [Subscriber],
		messages: [Message]
	) {
		self.id = id
		self.created = created
		self.updated = updated
		self.startedBy = startedBy
		self.unreadCount = unreadCount
		self.subscribers = subscribers
		self.messages = messages
	}
}
