//
//  MerchantBlock.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct MerchantBlock: AbstractBlock & Equatable {
	public let id: UUID
	public let title: String
	public let slug: String
	public let summary: String?
	public let link: String?
	public let location: BlockLocation?
	public let merchants: [Merchant]

	public init(
		id: UUID,
		title: String,
		slug: String,
		summary: String? = nil,
		link: String? = nil,
		location: BlockLocation? = nil,
		merchants: [Merchant]
	) {
		self.id = id
		self.title = title
		self.slug = slug
		self.summary = summary
		self.link = link
		self.location = location
		self.merchants = merchants
	}
}
