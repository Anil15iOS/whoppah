//
//  Product.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Product: MediaQueries & Equatable & ProductTileItemRepresentable {
	public let id: UUID
	public let identifier: String
	public let state: ProductState
	public let curatedBy: Member?
	public let curatedAt: Date?
	public let curatedReason: CurationReason?
	public let curatedCustom: String?
	public let title: String
	public let slug: String
	public let link: String
	public let description: String?
	public let condition: ProductCondition
	public let quality: ProductQuality
	public let brand: Brand?
	public let lastBoost: Date?
	public let created: Date?
	public let sku: String?
	public let mpn: String?
	public let gtin: String?
	public let numberOfItems: Int?
	public let pushToTopCount: Int?
	public let width: Int?
	public let height: Int?
	public let depth: Int?
	public let seatHeight: Int?
	public let weight: Int?
	public let artOrientation: ArtOrientation?
	public let artSize: ArtSize?
	public let deliveryMethod: DeliveryMethod
	public let shippingMethod: ShippingMethod?
	public let shippingMethodPrices: [ShippingMethodCountryPrice]
	public let shippingCost: Price
	public let customShippingCost: Price?
	public let isInShowroom: Bool?
	public let showroomZone: String?
	public let showroomState: String?
	public let showroomServiceOrder: UUID?
	public let merchantFee: Fee?
	public let auction: Auction?
	public let order: UUID?
	public let auctions: [Auction]
	public let address: Address?
	public let merchant: Merchant
	public let categories: [Category]
	public let audio: Audio?
	public let audios: [Audio]
	public let image: Image?
	public let images: [Image]
	public let video: Video?
	public let videos: [Video]
	public let arobject: ARObject?
	public let arobjects: [ARObject]
	public let brandSuggestion: String?
	public let designerSuggestion: String?
	public let artistSuggestion: String?
	public var favorite: Favorite?
	public let favoriteCount: Int
	public let viewCount: Int
	public let shareLink: String
	// Custom parameter
	public let fullImages: [Image]
	// Custom parameter
	public let thumbnails: [Image]
	// Custom parameter
	public let brands: [Brand]
	// Custom parameter
	public let colors: [Color]
	// Custom parameter
	public let labels: [Label]
	// Custom parameter
	public let styles: [Style]
	// Custom parameter
	public let artists: [Artist]
	// Custom parameter
	public let designers: [Designer]
	// Custom parameter
	public let materials: [Material]

	public init(
		id: UUID,
		identifier: String,
		state: ProductState,
		curatedBy: Member? = nil,
		curatedAt: Date? = nil,
		curatedReason: CurationReason? = nil,
		curatedCustom: String? = nil,
		title: String,
		slug: String,
		link: String,
		description: String? = nil,
		condition: ProductCondition,
		quality: ProductQuality,
		brand: Brand? = nil,
		lastBoost: Date? = nil,
		created: Date? = nil,
		sku: String? = nil,
		mpn: String? = nil,
		gtin: String? = nil,
		numberOfItems: Int? = nil,
		pushToTopCount: Int? = nil,
		width: Int? = nil,
		height: Int? = nil,
		depth: Int? = nil,
		seatHeight: Int? = nil,
		weight: Int? = nil,
		artOrientation: ArtOrientation? = nil,
		artSize: ArtSize? = nil,
		deliveryMethod: DeliveryMethod,
		shippingMethod: ShippingMethod? = nil,
		shippingMethodPrices: [ShippingMethodCountryPrice],
		shippingCost: Price,
		customShippingCost: Price? = nil,
		isInShowroom: Bool? = nil,
		showroomZone: String? = nil,
		showroomState: String? = nil,
		showroomServiceOrder: UUID? = nil,
		merchantFee: Fee? = nil,
		auction: Auction? = nil,
		order: UUID? = nil,
		auctions: [Auction],
		address: Address? = nil,
		merchant: Merchant,
		categories: [Category],
		audio: Audio? = nil,
		audios: [Audio],
		image: Image? = nil,
		images: [Image],
		video: Video? = nil,
		videos: [Video],
		arobject: ARObject? = nil,
		arobjects: [ARObject],
		brandSuggestion: String? = nil,
		designerSuggestion: String? = nil,
		artistSuggestion: String? = nil,
		favorite: Favorite? = nil,
		favoriteCount: Int,
		viewCount: Int,
		shareLink: String,
		fullImages: [Image],
		thumbnails: [Image],
		brands: [Brand],
		colors: [Color],
		labels: [Label],
		styles: [Style],
		artists: [Artist],
		designers: [Designer],
		materials: [Material]
	) {
		self.id = id
		self.identifier = identifier
		self.state = state
		self.curatedBy = curatedBy
		self.curatedAt = curatedAt
		self.curatedReason = curatedReason
		self.curatedCustom = curatedCustom
		self.title = title
		self.slug = slug
		self.link = link
		self.description = description
		self.condition = condition
		self.quality = quality
		self.brand = brand
		self.lastBoost = lastBoost
		self.created = created
		self.sku = sku
		self.mpn = mpn
		self.gtin = gtin
		self.numberOfItems = numberOfItems
		self.pushToTopCount = pushToTopCount
		self.width = width
		self.height = height
		self.depth = depth
		self.seatHeight = seatHeight
		self.weight = weight
		self.artOrientation = artOrientation
		self.artSize = artSize
		self.deliveryMethod = deliveryMethod
		self.shippingMethod = shippingMethod
		self.shippingMethodPrices = shippingMethodPrices
		self.shippingCost = shippingCost
		self.customShippingCost = customShippingCost
		self.isInShowroom = isInShowroom
		self.showroomZone = showroomZone
		self.showroomState = showroomState
		self.showroomServiceOrder = showroomServiceOrder
		self.merchantFee = merchantFee
		self.auction = auction
		self.order = order
		self.auctions = auctions
		self.address = address
		self.merchant = merchant
		self.categories = categories
		self.audio = audio
		self.audios = audios
		self.image = image
		self.images = images
		self.video = video
		self.videos = videos
		self.arobject = arobject
		self.arobjects = arobjects
		self.brandSuggestion = brandSuggestion
		self.designerSuggestion = designerSuggestion
		self.artistSuggestion = artistSuggestion
		self.favorite = favorite
		self.favoriteCount = favoriteCount
		self.viewCount = viewCount
		self.shareLink = shareLink
		self.fullImages = fullImages
		self.thumbnails = thumbnails
		self.brands = brands
		self.colors = colors
		self.labels = labels
		self.styles = styles
		self.artists = artists
		self.designers = designers
		self.materials = materials
	}
}
