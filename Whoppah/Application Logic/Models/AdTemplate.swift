//
//  AdTemplate.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

public class AdTemplate {
    var id: UUID?
    var state: GraphQL.ProductState?
    var slug: String?
    var title: String?
    var description: String?
    var price: PriceInput?
    var categories = [AdAttribute]()
    var merchantFee: Fee? = nil
    
    var styles: [AdAttribute]? = []
    var quality: GraphQL.ProductQuality?
    var colors: [Color]? = []
    var materials: [AdAttribute]? = []
    var brand: AdAttribute?
    var brandSuggestion: String?

    var artists = [AdAttribute]()
    var designers = [AdAttribute]()
    var images: [Image]? = []
    var videos: [Video]? = []
    var shippingMethod: ShippingMethodInput?
    var delivery: GraphQL.DeliveryMethod?
    var location: LegacyAddress?
    var settings: ProductSettingsInput = ProductSettingsInput(allowBidding: true, allowBuyNow: true, minBid: nil)
    public var width: Int?
    public var height: Int?
    public var depth: Int?

    init() {}

    func getInput(merchantId: UUID) -> GraphQL.ProductInput {
        let shippingInputPrice = shippingMethod?.price

        let shippingPrice = shippingInputPrice != nil ? GraphQL.PriceInput(amount: shippingInputPrice?.amount ?? 0.0, currency: shippingInputPrice?.currency ?? .eur) : nil
        let shippingUUID = shippingMethod?.method?.id
        let brandSlug = brand?.slug
        // Don't 'save' unknown brands
        let inputBrand = brandSlug != uniqueCustomAttributeSlug && brandSlug != unknownAttributeSlug ? brand : nil
        // Custom brands are handled differently
        let customBrand = brandSlug == uniqueCustomAttributeSlug ? brand : nil
        // Don't 'save' unknown brands
        let artistIds = artists.filter { $0.slug != uniqueCustomAttributeSlug && $0.slug != unknownAttributeSlug }.compactMap { $0.id }
        let designerIds = designers.filter { $0.slug != uniqueCustomAttributeSlug && $0.slug != unknownAttributeSlug }.compactMap { $0.id }
        let buyNowPrice: GraphQL.PriceInput? = price != nil ? GraphQL.PriceInput(amount: price!.amount, currency: price!.currency) : nil
        let originalPrice: GraphQL.PriceInput? = price != nil ? GraphQL.PriceInput(amount: price!.amount, currency: price!.currency) : nil
        let minBid = settings.minBid?.asGraphInput()
        return GraphQL.ProductInput(title: title ?? "",
                                    description: description,
                                    condition: nil,
                                    quality: quality ?? .good,
                                    sku: nil,
                                    mpn: nil,
                                    gtin: nil,
                                    width: width,
                                    height: height,
                                    depth: depth,
                                    weight: nil,
                                    deliveryMethod: delivery ?? .pickup,
                                    shippingMethod: shippingUUID,
                                    shippingCost: shippingPrice,
                                    address: location?.id,
                                    merchant: merchantId,
                                    buyNowPrice: buyNowPrice,
                                    originalPrice: originalPrice,
                                    minimumBid: minBid,
                                    allowBid: settings.allowBidding,
                                    allowBuyNow: settings.allowBuyNow,
                                    categories: categories.map { $0.id },
                                    brand: inputBrand?.id ?? nil,
                                    designers: designerIds,
                                    artists: artistIds,
                                    styles: styles?.map { $0.id } ?? [],
                                    materials: [],
                                    colors: colors?.map { $0.id } ?? [],
                                    brandSuggestion: customBrand?.title ?? nil,
                                    designerSuggestion: nil,
                                    artistSuggestion: nil)
    }

    func getDeprecatedCategoryText() -> String {
        var category: String?

        if let savedCategory = self.categories.first {
            category = savedCategory.title
        }
        return category ?? ""
    }
}

let adUpdated = Notification.Name("com.whoppah.app.create.ad.updated")
