//
//  updateReviewInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct updateReviewInput {
	public let review: String?
	public let score: Int?
	public let anonymous: Bool?

	public init(
		review: String? = nil,
		score: Int? = nil,
		anonymous: Bool? = nil
	) {
		self.review = review
		self.score = score
		self.anonymous = anonymous
	}
}
