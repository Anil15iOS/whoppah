//
//  ProductTileItem.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 18/03/2022.
//

import Foundation

public struct ProductTileItem: ProductTileItemRepresentable, Equatable, Hashable, Identifiable {
    public let id: UUID
    public let state: ProductState
    public let title: String
    public let slug: String
    public let description: String?
    public var favorite: Favorite?
    public let auction: Auction?
    public let image: Image?
    @IgnoreEquatable
    public var attributes: [AbstractAttribute]?
    
    public init(id: UUID,
                state: ProductState,
                title: String,
                slug: String,
                description: String?,
                favorite: Favorite?,
                auction: Auction?,
                image: Image?,
                attributes: [AbstractAttribute]? = nil)
    {
        self.id = id
        self.state = state
        self.title = title
        self.slug = slug
        self.description = description
        self.favorite = favorite
        self.auction = auction
        self.image = image
        self.attributes = attributes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var clone: Self {
        .init(id: self.id,
              state: self.state,
              title: self.title,
              slug: self.slug,
              description: self.description,
              favorite: self.favorite,
              auction: self.auction,
              image: self.image,
              attributes: self.attributes)
    }
    
    public var labelAttributes: [WhoppahModel.Label]? {
        attributes?.compactMap({ $0 as? WhoppahModel.Label })
    }
}
