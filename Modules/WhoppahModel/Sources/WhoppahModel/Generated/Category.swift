//
//  Category.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct Category: MediaQueries & Equatable {
	public let id: UUID
	public let parent: UUID?
	public let children: [Category]?
	public let title: String
	public let description: String?
	public let slug: String
	public let link: String?
	public let level: Int?
	public let route: String?
	public let showInStyles: Bool?
	public let showInBrands: Bool?
	public let image: Image?
	public let images: [Image]
	public let video: Video?
	public let videos: [Video]

	public init(
		id: UUID,
		parent: UUID? = nil,
		children: [Category]? = nil,
		title: String,
		description: String? = nil,
		slug: String,
		link: String? = nil,
		level: Int? = nil,
		route: String? = nil,
		showInStyles: Bool? = nil,
		showInBrands: Bool? = nil,
		image: Image? = nil,
		images: [Image],
		video: Video? = nil,
		videos: [Video]
	) {
		self.id = id
		self.parent = parent
		self.children = children
		self.title = title
		self.description = description
		self.slug = slug
		self.link = link
		self.level = level
		self.route = route
		self.showInStyles = showInStyles
		self.showInBrands = showInBrands
		self.image = image
		self.images = images
		self.video = video
		self.videos = videos
	}
}
