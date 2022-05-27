//
//  ProductBySlug+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 17/05/2022.
//

import Foundation
import WhoppahModel


extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Brand: WhoppahModelConvertable {
    var toWhoppahModel: Brand {
        return .init(id: self.id,
                     title: self.title,
                     slug: self.slug)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.ShippingMethod: WhoppahModelConvertable {
    var toWhoppahModel: ShippingMethod {
        return .init(id: self.id,
                     title: self.title,
                     description: nil,
                     slug: self.slug,
                     price: self.price.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.ShippingMethod.Price: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.ShippingCost: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.CustomShippingCost: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction.BuyNowPrice: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction.MinimumBid: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction.SoldAt: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        .init(amount: self.amount,
              currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction: WhoppahModelConvertable {
    var toWhoppahModel: Auction {
        return .init(id: self.id,
                     identifier: "",
                     state: self.state.toWhoppahModel,
                     product: UUID(),
                     startDate: self.startDate?.toWhoppahModel,
                     expiryDate: self.expiryDate?.toWhoppahModel,
                     endDate: self.endDate?.toWhoppahModel,
                     buyNowPrice: self.buyNowPrice?.toWhoppahModel,
                     minimumBid: self.minimumBid?.toWhoppahModel,
                     soldAt: self.soldAt?.toWhoppahModel,
                     allowBid: self.allowBid,
                     allowBuyNow: self.allowBuyNow,
                     bidCount: self.bidCount,
                     highestBid: self.highestBid?.id,
                     bids: self.bids.map { $0.toWhoppahModel })
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction.Bid.Amount: WhoppahModelConvertable {
    var toWhoppahModel: Price {
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Auction.Bid: WhoppahModelConvertable {
    var toWhoppahModel: Bid {
        
        return .init(id: self.id,
                     auction: UUID(),
                     buyer: self.buyer.id,
                     merchant: UUID(),
                     state: self.state.toWhoppahModel,
                     created: Date(),
                     expiryDate: Date(),
                     amount: self.amount.toWhoppahModel,
                     isCounter: false)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Address.Location: WhoppahModelConvertable {
    var toWhoppahModel: Location {
        return .init(latitude: self.latitude,
                     longitude: self.longitude)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Address: WhoppahModelConvertable {
    var toWhoppahModel: Address {
        return .init(id: self.id,
                     line1: self.line1,
                     postalCode: self.postalCode,
                     city: self.city,
                     country: self.country)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Favorite: WhoppahModelConvertable {
    var toWhoppahModel: Favorite {
        return .init(id: self.id,
                     created: Date(),
                     collection: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Video: WhoppahModelConvertable {
    var toWhoppahModel: Video {
        return .init(id: self.id,
                     url: self.url,
                     thumbnail: self.thumbnail,
                     type: .default)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Arobject: WhoppahModelConvertable {
    var toWhoppahModel: ARObject {
        return .init(id: self.id,
                     url: self.url,
                     platform: self.platform.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Merchant.Avatar: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Image {
        .init(id: self.id,
              url: self.url,
              type: .avatar,
              orientation: .landscape,
              width: nil,
              height: nil,
              aspectRatio: nil,
              position: 0,
              backgroundColor: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Merchant: WhoppahModelConvertable {
    var toWhoppahModel: Merchant {
        
        //TODO: Marko - From Graph missing currency
        return .init(id: self.id,
                     type: self.type.toWhoppahModel,
                     name: self.name,
                     slug: "",
                     created: self.created.toWhoppahModel,
                     biography: nil,
                     url: nil,
                     expertSeller: self.expertSeller,
                     phone: nil,
                     email: nil,
                     businessName: self.businessName,
                     taxId: nil,
                     vatId: nil,
                     vatIdRegistrar: nil,
                     numberOfBuys: nil,
                     numberOfBids: nil,
                     numberOfSells: nil,
                     numberOfAds: nil,
                     numberOfFavorites: nil,
                     complianceLevel: self.complianceLevel,
                     discount: nil,
                     fee: nil,
                     currency: Currency.eur,
                     referralCode: nil,
                     bankAccount: nil,
                     addresses: [],
                     members: [],
                     rating: self.rating,
                     image: self.avatar?.toWhoppahModel,
                     images: [],
                     video: nil,
                     videos: [],
                     favorites: [],
                     favoritecollections: [],
                     rawObject: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.FullImage: WhoppahModelConvertable {
    var toWhoppahModel: Image {
        return .init(id: self.id,
                     url: self.url,
                     type: .unknown,
                     position: 0)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Thumbnail: WhoppahModelConvertable {
    var toWhoppahModel: Image {
        return .init(id: self.id,
                     url: self.url,
                     type: .unknown,
                     position: 0)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsBrand: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Brand {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsColor: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Color {
        .init(id: self.id,
              title: self.title,
              description: self.description,
              slug: self.slug,
              hex: self.hex)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsLabel: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Label {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              hex: self.color)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsStyle: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Style {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsArtist: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Artist {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsDesigner: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Designer {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug,
              countryOfOrigin: nil)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Attribute.AsMaterial: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Material {
        .init(id: self.id,
              title: "",
              description: self.description,
              slug: self.slug)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.ShippingMethodPrice.Price: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.ShippingMethodPrice: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.ShippingMethodCountryPrice {
        .init(country: self.country,
              price: self.price.toWhoppahModel)
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug.Category: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Category {
        
        return .init(id: self.id,
                     title: self.title,
                     slug: self.slug,
                     images: [],
                     videos: [])
    }
}

extension GraphQL.ProductBySlugQuery.Data.ProductBySlug: WhoppahModelConvertable {
    var toWhoppahModel: Product {
        
        let brands = self.attributes.compactMap { $0.asBrand?.toWhoppahModel }
        let colors = self.attributes.compactMap { $0.asColor?.toWhoppahModel }
        let labels = self.attributes.compactMap { $0.asLabel?.toWhoppahModel }
        let styles = self.attributes.compactMap { $0.asStyle?.toWhoppahModel }
        let artists = self.attributes.compactMap { $0.asArtist?.toWhoppahModel }
        let designers = self.attributes.compactMap { $0.asDesigner?.toWhoppahModel }
        let materials = self.attributes.compactMap { $0.asMaterial?.toWhoppahModel }

        return .init(id: self.id,
                     identifier: "",
                     state: self.state.toWhoppahModel,
                     curatedBy: nil,
                     curatedAt: nil,
                     curatedReason: nil,
                     curatedCustom: nil,
                     title: self.title,
                     slug: self.slug,
                     link: "",
                     description: self.description,
                     condition: self.condition.toWhoppahModel,
                     quality: self.quality.toWhoppahModel,
                     brand: self.brand?.toWhoppahModel,
                     lastBoost: nil,
                     sku: nil,
                     mpn: nil,
                     gtin: nil,
                     numberOfItems: nil,
                     pushToTopCount: nil,
                     width: self.width,
                     height: self.height,
                     depth: self.depth,
                     seatHeight: nil,
                     weight: nil,
                     artOrientation: nil,
                     artSize: nil,
                     deliveryMethod: self.deliveryMethod.toWhoppahModel,
                     shippingMethod: self.shippingMethod?.toWhoppahModel,
                     shippingMethodPrices: self.shippingMethodPrices.map({ $0.toWhoppahModel }),
                     shippingCost: self.shippingCost.toWhoppahModel,
                     customShippingCost: self.customShippingCost?.toWhoppahModel,
                     isInShowroom: self.isInShowroom,
                     showroomZone: nil,
                     showroomState: nil,
                     showroomServiceOrder: nil,
                     auction: self.auction?.toWhoppahModel,
                     order: nil,
                     auctions: [],
                     address: self.address?.toWhoppahModel,
                     merchant: self.merchant.toWhoppahModel,
                     categories: self.categories.map { $0.toWhoppahModel },
                     audio: nil,
                     audios: [],
                     image: nil,
                     images: [],
                     video: nil,
                     videos: self.videos.map { $0.toWhoppahModel },
                     arobject: self.arobject?.toWhoppahModel,
                     arobjects: [],
                     brandSuggestion: self.brandSuggestion,
                     designerSuggestion: self.designerSuggestion,
                     artistSuggestion: self.artistSuggestion,
                     favorite: self.favorite?.toWhoppahModel,
                     favoriteCount: self.favoriteCount,
                     viewCount: self.viewCount,
                     shareLink: self.shareLink,
                     fullImages: self.fullImages.map { $0.toWhoppahModel },
                     thumbnails: self.thumbnails.map { $0.toWhoppahModel },
                     brands: brands,
                     colors: colors,
                     labels: labels,
                     styles: styles,
                     artists: artists,
                     designers: designers,
                     materials: materials)
    }
}
