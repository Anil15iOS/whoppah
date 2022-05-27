//
//  Product+Extensions.swift
//  
//
//  Created by Marko Stojkovic on 29.4.22..
//

import Foundation

public extension Product {
    var clone: Self {
        .init(id: self.id,
              identifier: self.identifier,
              state: self.state,
              title: self.title,
              slug: self.slug,
              link: self.link,
              condition: self.condition,
              quality: self.quality,
              deliveryMethod: self.deliveryMethod,
              shippingMethodPrices: self.shippingMethodPrices,
              shippingCost: self.shippingCost,
              auctions: self.auctions,
              merchant: self.merchant,
              categories: self.categories,
              audios: self.audios,
              images: self.images,
              videos: self.videos,
              arobjects: self.arobjects,
              favoriteCount: self.favoriteCount,
              viewCount: self.viewCount,
              shareLink: self.shareLink,
              fullImages: self.fullImages,
              thumbnails: self.thumbnails,
              brands: self.brands,
              colors: self.colors,
              labels: self.labels,
              styles: self.styles,
              artists: self.artists,
              designers: self.designers,
              materials: self.materials)
    }
}
