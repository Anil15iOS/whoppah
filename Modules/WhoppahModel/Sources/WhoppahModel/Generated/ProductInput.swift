//
//  ProductInput.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct ProductInput {
	public let title: String
	public let description: String?
	public let condition: ProductCondition?
	public let quality: ProductQuality
	public let sku: String?
	public let mpn: String?
	public let gtin: String?
	public let width: Int?
	public let height: Int?
	public let depth: Int?
	public let seatHeight: Int?
	public let weight: Int?
	public let artOrientation: ArtOrientation?
	public let deliveryMethod: DeliveryMethod
	public let shippingMethod: UUID?
	public let shippingCost: PriceInput?
	public let address: UUID?
	public let merchant: UUID
	public let quantity: Int?
	public let numberOfItems: Int?
	public let buyNowPrice: PriceInput?
	public let originalPrice: PriceInput?
	public let minimumBid: PriceInput?
	public let allowBid: Bool
	public let allowBuyNow: Bool
	public let reactivate: Bool?
	public let categories: [UUID]
	public let brand: UUID?
	public let designers: [UUID]
	public let artists: [UUID]
	public let styles: [UUID]
	public let materials: [UUID]
	public let colors: [UUID]
	public let usageSigns: [UUID]
	public let additionalInfo: [UUID]
	public let subjects: [UUID]
	public let brandSuggestion: String?
	public let designerSuggestion: String?
	public let artistSuggestion: String?
	public let isInShowroom: Bool?

	public init(
		title: String,
		description: String? = nil,
		condition: ProductCondition? = nil,
		quality: ProductQuality,
		sku: String? = nil,
		mpn: String? = nil,
		gtin: String? = nil,
		width: Int? = nil,
		height: Int? = nil,
		depth: Int? = nil,
		seatHeight: Int? = nil,
		weight: Int? = nil,
		artOrientation: ArtOrientation? = nil,
		deliveryMethod: DeliveryMethod,
		shippingMethod: UUID? = nil,
		shippingCost: PriceInput? = nil,
		address: UUID? = nil,
		merchant: UUID,
		quantity: Int? = nil,
		numberOfItems: Int? = nil,
		buyNowPrice: PriceInput? = nil,
		originalPrice: PriceInput? = nil,
		minimumBid: PriceInput? = nil,
		allowBid: Bool,
		allowBuyNow: Bool,
		reactivate: Bool? = nil,
		categories: [UUID],
		brand: UUID? = nil,
		designers: [UUID],
		artists: [UUID],
		styles: [UUID],
		materials: [UUID],
		colors: [UUID],
		usageSigns: [UUID],
		additionalInfo: [UUID],
		subjects: [UUID],
		brandSuggestion: String? = nil,
		designerSuggestion: String? = nil,
		artistSuggestion: String? = nil,
		isInShowroom: Bool? = nil
	) {
		self.title = title
		self.description = description
		self.condition = condition
		self.quality = quality
		self.sku = sku
		self.mpn = mpn
		self.gtin = gtin
		self.width = width
		self.height = height
		self.depth = depth
		self.seatHeight = seatHeight
		self.weight = weight
		self.artOrientation = artOrientation
		self.deliveryMethod = deliveryMethod
		self.shippingMethod = shippingMethod
		self.shippingCost = shippingCost
		self.address = address
		self.merchant = merchant
		self.quantity = quantity
		self.numberOfItems = numberOfItems
		self.buyNowPrice = buyNowPrice
		self.originalPrice = originalPrice
		self.minimumBid = minimumBid
		self.allowBid = allowBid
		self.allowBuyNow = allowBuyNow
		self.reactivate = reactivate
		self.categories = categories
		self.brand = brand
		self.designers = designers
		self.artists = artists
		self.styles = styles
		self.materials = materials
		self.colors = colors
		self.usageSigns = usageSigns
		self.additionalInfo = additionalInfo
		self.subjects = subjects
		self.brandSuggestion = brandSuggestion
		self.designerSuggestion = designerSuggestion
		self.artistSuggestion = artistSuggestion
		self.isInShowroom = isInShowroom
	}
}
