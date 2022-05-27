//
//  Merchant.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Merchant: MediaQueries & Equatable {
	public let id: UUID
	public let type: MerchantType
	public let name: String
	public let slug: String
	public let created: Date
	public let biography: String?
	public let url: String?
	public let expertSeller: Bool?
	public let phone: String?
	public let email: String?
	public let businessName: String?
	public let taxId: String?
	public let vatId: String?
	public let vatIdRegistrar: String?
	public let numberOfBuys: Int?
	public let numberOfBids: Int?
	public let numberOfSells: Int?
	public let numberOfAds: Int?
	public let numberOfFavorites: Int?
	public let complianceLevel: Int?
	public let discount: Discount?
	public let fee: Fee?
	public let currency: Currency
	public let referralCode: String?
	public let bankAccount: BankAccount?
	public let addresses: [Address]
	public let members: [Member]
	public let rating: Int?
	public let image: Image?
	public let images: [Image]
	public let video: Video?
	public let videos: [Video]
	public let favorites: [Favorite]
	public let favoritecollections: [FavoriteCollection]
	// Temporary while switching between new and old architures. Will hold GraphQL object.
	@IgnoreEquatable public var rawObject: AnyObject?

	public init(
		id: UUID,
		type: MerchantType,
		name: String,
		slug: String,
		created: Date,
		biography: String? = nil,
		url: String? = nil,
		expertSeller: Bool? = nil,
		phone: String? = nil,
		email: String? = nil,
		businessName: String? = nil,
		taxId: String? = nil,
		vatId: String? = nil,
		vatIdRegistrar: String? = nil,
		numberOfBuys: Int? = nil,
		numberOfBids: Int? = nil,
		numberOfSells: Int? = nil,
		numberOfAds: Int? = nil,
		numberOfFavorites: Int? = nil,
		complianceLevel: Int? = nil,
		discount: Discount? = nil,
		fee: Fee? = nil,
		currency: Currency,
		referralCode: String? = nil,
		bankAccount: BankAccount? = nil,
		addresses: [Address],
		members: [Member],
		rating: Int? = nil,
		image: Image? = nil,
		images: [Image],
		video: Video? = nil,
		videos: [Video],
		favorites: [Favorite],
		favoritecollections: [FavoriteCollection],
		rawObject: AnyObject? = nil
	) {
		self.id = id
		self.type = type
		self.name = name
		self.slug = slug
		self.created = created
		self.biography = biography
		self.url = url
		self.expertSeller = expertSeller
		self.phone = phone
		self.email = email
		self.businessName = businessName
		self.taxId = taxId
		self.vatId = vatId
		self.vatIdRegistrar = vatIdRegistrar
		self.numberOfBuys = numberOfBuys
		self.numberOfBids = numberOfBids
		self.numberOfSells = numberOfSells
		self.numberOfAds = numberOfAds
		self.numberOfFavorites = numberOfFavorites
		self.complianceLevel = complianceLevel
		self.discount = discount
		self.fee = fee
		self.currency = currency
		self.referralCode = referralCode
		self.bankAccount = bankAccount
		self.addresses = addresses
		self.members = members
		self.rating = rating
		self.image = image
		self.images = images
		self.video = video
		self.videos = videos
		self.favorites = favorites
		self.favoritecollections = favoritecollections
		self.rawObject = rawObject
	}
}
