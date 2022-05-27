//
//  Product+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/04/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Product {
    
    static var random: Self {
        Self.randomWithId(productId: UUID())
    }
    
    static func randomWithId(productId: UUID) -> Self {
        var images = [WhoppahModel.Image]()

        for i in 0..<5 {
            images.append(
                .init(id: productId,
                      url: "https://picsum.photos/800/1200?id=\(productId.uuidString)\(i)",
                      type: .detail,
                      position: 0))
        }
        
        var thumbnails = [WhoppahModel.Image]()

        for i in 0..<5 {
            thumbnails.append(
                .init(id: productId,
                      url: "https://picsum.photos/400/600?id=\(productId.uuidString)\(i)",
                      type: .thumbnail,
                      position: 0))
        }
        
        return .init(
            id: productId,
            identifier: RandomWord.generate(10),
            state: .random,
            title: RandomWord.randomWords(3...5),
            slug: RandomWord.generate(10),
            link: "",
            description: RandomWord.randomWords(8...20),
            condition: .random,
            quality: .random,
            brand: .random,
            numberOfItems: Int.random(in: 1...6),
            width: Int.random(in: 20...200),
            height: Int.random(in: 20...200),
            depth: Int.random(in: 20...200),
            seatHeight: Int.random(in: 20...200),
            weight: Int.random(in: 20...200),
            deliveryMethod: .random,
            shippingMethod: .random,
            shippingMethodPrices: [],
            shippingCost: .random,
            customShippingCost: .random,
            isInShowroom: Int.random(in: 0...1) == 1,
            auctions: [],
            merchant: .random,
            categories: [],
            audios: [],
            image: nil,
            images: images,
            video: nil,
            videos: [],
            arobject: .dummy,
            arobjects: [],
            favoriteCount: Int.random(in: 0...10),
            viewCount: Int.random(in: 0...10000),
            shareLink: "",
            fullImages: images,
            thumbnails: thumbnails,
            brands: [],
            colors: [],
            labels: [],
            styles: [],
            artists: [],
            designers: [],
            materials: [])
    }
}

extension WhoppahModel.ProductState {
    static var random: Self {
        var cases = self.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases.randomElement() ?? .accepted
    }
}

extension WhoppahModel.ProductCondition {
    static var random: Self {
        var cases = self.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases.randomElement() ?? .used
    }
}

extension WhoppahModel.ProductQuality {
    static var random: Self {
        var cases = self.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases.randomElement() ?? .great
    }
}

extension WhoppahModel.Brand {
    static var random: Self {
        .init(id: UUID(),
              title: RandomWord.randomWords(2...4),
              description: RandomWord.randomWords(6...8),
              slug: RandomWord.generate(10),
              countryOfOrigin: RandomWord.generate(10))
    }
}

extension WhoppahModel.DeliveryMethod {
    static var random: Self {
        var cases = self.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases.randomElement() ?? .pickupDelivery
    }
}

extension WhoppahModel.ShippingMethod {
    static var random: Self {
        .init(id: UUID(),
              title: RandomWord.randomWords(2...4),
              description: RandomWord.randomWords(8...16),
              slug: RandomWord.generate(10),
              price: .random)
    }
}

extension WhoppahModel.Price {
    static var random: Self {
        .init(amount: Double.random(in: 10...10000),
              currency: .random)
    }
}

extension WhoppahModel.Currency {
    static var random: Self {
        var cases = self.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases.randomElement() ?? .eur
    }
}

extension WhoppahModel.Merchant {
    static var random: Self {
        .init(id: UUID(),
              type: .business,
              name: RandomWord.randomWords(2...3),
              slug: RandomWord.generate(10),
              created: Date(),
              currency: .random,
              addresses: [],
              members: [],
              images: [],
              videos: [],
              favorites: [],
              favoritecollections: [])
    }
}

extension WhoppahModel.ARObject {
    static var dummy: Self {
        .init(id: UUID(),
              url: "https://storage.googleapis.com/whoppah-testing/ar%20object/b0/a8/b0a820a2-477a-49b5-ada5-074b8262e1bb/original.usdz",
              platform: .ios)
    }
}

extension WhoppahModel.ProductTileItem {
    static var random: Self {
        let product = WhoppahModel.Product.random
        return .init(id: product.id,
                  state: product.state,
                  title: product.title,
                  slug: product.slug,
                  description: product.description,
                  favorite: product.favorite,
                  auction: product.auction,
                  image: product.image,
                  attributes: [])
    }
}
