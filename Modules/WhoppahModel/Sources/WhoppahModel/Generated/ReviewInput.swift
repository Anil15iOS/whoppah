//
//  ReviewInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ReviewInput {
	public let order: UUID
	public let review: String
	public let score: Int
	public var anonymous: Bool = false

	public init(
		order: UUID,
		review: String,
		score: Int,
		anonymous: Bool = false
	) {
		self.order = order
		self.review = review
		self.score = score
		self.anonymous = anonymous
	}
}
