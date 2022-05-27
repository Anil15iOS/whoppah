//
//  Review.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Review: Equatable {
	public let id: UUID
	public let order: Order
	public let reviewer: Merchant?
	public let review: String?
	public let score: Int?
	public let created: Date?
	public let anonymous: Bool?

	public init(
		id: UUID,
		order: Order,
		reviewer: Merchant? = nil,
		review: String? = nil,
		score: Int? = nil,
		created: Date? = nil,
		anonymous: Bool? = nil
	) {
		self.id = id
		self.order = order
		self.reviewer = reviewer
		self.review = review
		self.score = score
		self.created = created
		self.anonymous = anonymous
	}
}
