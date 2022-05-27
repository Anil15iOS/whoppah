//  
//  ProductDetailView+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import Foundation
import SwiftUI
import WhoppahModel

public extension ProductDetailView {
    struct Model: Equatable {
        let heroImageComponent: HeroImageComponent
        var soldInfo: SoldInfo
        let reservedInfo: ReservedInfo
        let productTitle: ProductTitle
        let sellerBoost: SellerBoost
        let productDetails: ProductDetails
        let sellerComponent: SellerComponent
        let productCondition: ProductCondition
        let shippingInfo: ShippingInfo
        let buyerProtection: BuyerProtection
        let benefits: Benefits
        var relatedProducts: RelatedProducts
        let contactSupport: ContactSupport
        let bidComponent: BidComponent
        let review: ReviewsComponent
        let viewInAugmentedReality: String
        var userNotSignedInTitle: String
        var userNotSignedInDescription: String
        var product: WhoppahModel.Product?

        public init(heroImageComponent: HeroImageComponent,
                    soldInfo: SoldInfo,
                    reservedInfo: ReservedInfo,
                    productTitle: ProductTitle,
                    sellerBoost: SellerBoost,
                    productDetails: ProductDetails,
                    sellerComponent: SellerComponent,
                    productCondition: ProductCondition,
                    shippingInfo: ShippingInfo,
                    buyerProtection: BuyerProtection,
                    benefits: Benefits,
                    relatedProducts: RelatedProducts,
                    contactSupport: ContactSupport,
                    review: ReviewsComponent,
                    bidComponent: BidComponent,
                    viewInAugmentedReality: String,
                    userNotSignedInTitle: String,
                    userNotSignedInDescription: String,
                    product: WhoppahModel.Product?) {
            self.heroImageComponent = heroImageComponent
            self.soldInfo = soldInfo
            self.reservedInfo = reservedInfo
            self.productTitle = productTitle
            self.sellerBoost = sellerBoost
            self.productDetails = productDetails
            self.sellerComponent = sellerComponent
            self.productCondition = productCondition
            self.shippingInfo = shippingInfo
            self.buyerProtection = buyerProtection
            self.benefits = benefits
            self.relatedProducts = relatedProducts
            self.contactSupport = contactSupport
            self.review = review
            self.bidComponent = bidComponent
            self.viewInAugmentedReality = viewInAugmentedReality
            self.userNotSignedInTitle = userNotSignedInTitle
            self.userNotSignedInDescription = userNotSignedInDescription
            self.product = product
        }
        
        public static var initial = Self(
            heroImageComponent: .initial,
            soldInfo: .initial,
            reservedInfo: .initial,
            productTitle: .initial,
            sellerBoost: .initial,
            productDetails: .initial,
            sellerComponent: .initial,
            productCondition: .initial,
            shippingInfo: .initial,
            buyerProtection: .initial,
            benefits: .initial,
            relatedProducts: .initial,
            contactSupport: .initial,
            review: .initial,
            bidComponent: .initial,
            viewInAugmentedReality: .empty,
            userNotSignedInTitle: .empty,
            userNotSignedInDescription: .empty,
            product: nil)
        
        ///TODO: Marko - this will be replaced with more accurate models
        public struct BidComponent: Equatable {
            let bidPlaceholderText: String
            @IgnoreEquatable
            var bidFromTitle: (Price) -> String
            let placeBidButtontitle: String
            @IgnoreEquatable
            var buyNowButtonTitle: (String) -> String
            let quickBidTitle: String
            let readMoreTitle: String
            let biddingInfoPopup: ModalPopupContent
            let bidConfirmationDialog: BidConfirmationDialog
            
            static var initial = Self(
                bidPlaceholderText: .empty,
                bidFromTitle: { _ in .empty },
                placeBidButtontitle: .empty,
                buyNowButtonTitle: { _ in .empty },
                quickBidTitle: .empty,
                readMoreTitle: .empty,
                biddingInfoPopup: .initial,
                bidConfirmationDialog: .initial)
            
            public init(bidPlaceholderText: String,
                        bidFromTitle: @escaping (Price) -> String,
                        placeBidButtontitle: String,
                        buyNowButtonTitle: @escaping (String) -> String,
                        quickBidTitle: String,
                        readMoreTitle: String,
                        biddingInfoPopup: ModalPopupContent,
                        bidConfirmationDialog: BidConfirmationDialog)
            {
                self.bidPlaceholderText = bidPlaceholderText
                self.bidFromTitle = bidFromTitle
                self.placeBidButtontitle = placeBidButtontitle
                self.buyNowButtonTitle = buyNowButtonTitle
                self.quickBidTitle = quickBidTitle
                self.readMoreTitle = readMoreTitle
                self.biddingInfoPopup = biddingInfoPopup
                self.bidConfirmationDialog = bidConfirmationDialog
            }
        }
        
        public struct BidConfirmationDialog: Equatable {
            let title: String
            @IgnoreEquatable
            var description: (String, String) -> String
            let confirmButtonTitle: String
            let cancelButtonTitle: String
            
            public init(title: String,
                        description: @escaping (String, String) -> String,
                        confirmButtonTitle: String,
                        cancelButtonTitle: String)
            {
                self.title = title
                self.description = description
                self.confirmButtonTitle = confirmButtonTitle
                self.cancelButtonTitle = cancelButtonTitle
            }
            
            static var initial = Self(
                title: .empty,
                description: { _, _ in .empty },
                confirmButtonTitle: .empty,
                cancelButtonTitle: .empty)
        }
        
        public struct HeroImageComponent: Equatable {
            let reportAdButtonTitle: String
            let reportUserButtonTitle: String
            let reportAdDescription: String
            let reportUserDescription: String
            let reportReason: String
            let reportDescriptionPlaceholder: String
            let reportSubmissionSuccess: String
            let cancelButtonTitle: String
            let sendButtonTitle: String
            let doneButtonTitle: String
            
            static var initial = Self(
                reportAdButtonTitle: .empty,
                reportUserButtonTitle: .empty,
                reportAdDescription: .empty,
                reportUserDescription: .empty,
                reportReason: .empty,
                reportDescriptionPlaceholder: .empty,
                reportSubmissionSuccess: .empty,
                cancelButtonTitle: .empty,
                sendButtonTitle: .empty,
                doneButtonTitle: .empty)
            
            public init(reportAdButtonTitle: String,
                        reportUserButtonTitle: String,
                        reportAdDescription: String,
                        reportUserDescription: String,
                        reportReason: String,
                        reportDescriptionPlaceholder: String,
                        reportSubmissionSuccess: String,
                        cancelButtonTitle: String,
                        sendButtonTitle: String,
                        doneButtonTitle: String)
            {
                self.reportAdButtonTitle = reportAdButtonTitle
                self.reportUserButtonTitle = reportUserButtonTitle
                self.reportAdDescription = reportAdDescription
                self.reportUserDescription = reportUserDescription
                self.reportReason = reportReason
                self.reportDescriptionPlaceholder = reportDescriptionPlaceholder
                self.reportSubmissionSuccess = reportSubmissionSuccess
                self.cancelButtonTitle = cancelButtonTitle
                self.sendButtonTitle = sendButtonTitle
                self.doneButtonTitle = doneButtonTitle
            }
        }
        
        ///TODO: Marko - this will be replaced with more accurate models
        public struct ShippingInfo: Equatable {
            let shippingTitle: String
            let shippingToTitle: String
            let shipping: String
            let productPickupTitle: String
            let free: String
            let description: String
            let shippingInfoTooltip: String
            let showroomCity: String
            
            static var initial = Self(
                shippingTitle: .empty,
                shippingToTitle: .empty,
                shipping: .empty,
                productPickupTitle: .empty,
                free: .empty,
                description: .empty,
                shippingInfoTooltip: .empty,
                showroomCity: .empty)
            
            public init(shippingTitle: String,
                        shippingToTitle: String,
                        shipping: String,
                        productPickupTitle: String,
                        free: String,
                        description: String,
                        shippingInfoTooltip: String,
                        showroomCity: String)
            {
                self.shippingTitle = shippingTitle
                self.shippingToTitle = shippingToTitle
                self.shipping = shipping
                self.productPickupTitle = productPickupTitle
                self.free = free
                self.description = description
                self.shippingInfoTooltip = shippingInfoTooltip
                self.showroomCity = showroomCity
            }
        }
        
        ///TODO: Marko - this will be replaced with real model at some point
        public struct SellerComponent: Equatable {
            let readReviewsButtonTitle: String
            let placeholder: String
            let image: String?
            let verifiedSeller: String
            let rating: Double
            let showSellersItems: String
            let showMyItems: String
            
            static var initial = Self(
                readReviewsButtonTitle: .empty,
                placeholder: .empty,
                image: nil,
                verifiedSeller: .empty,
                rating: 0,
                showSellersItems: .empty,
                showMyItems: .empty)
            
            public init(readReviewsButtonTitle: String,
                        placeholder: String,
                        image: String?,
                        verifiedSeller: String,
                        rating: Double,
                        showSellersItems: String,
                        showMyItems: String)
            {
                self.readReviewsButtonTitle = readReviewsButtonTitle
                self.placeholder = placeholder
                self.image = image
                self.verifiedSeller = verifiedSeller
                self.rating = rating
                self.showSellersItems = showSellersItems
                self.showMyItems = showMyItems
            }
        }
        
        public struct SoldInfo: Equatable {
            let title: String
            let description: String
            
            static var initial = Self(title: "",
                description: "")
            
            public init(title: String,
                        description: String)
            {
                self.title = title
                self.description = description
            }
        }
        
        public struct ReservedInfo: Equatable {
            let title: String
            let description: String
            
            static var initial = Self(
                title: "",
                description: "")
            
            public init(title: String,
                        description: String)
            {
                self.title = title
                self.description = description
            }
        }
        
        public struct BuyerProtection: Equatable {
            let title: String
            let description: String
            let moreInformationButtonTitle: String
            let buyerProtectionInfo: ModalPopupContent
            
            static var initial = Self(
                title: .empty,
                description: .empty,
                moreInformationButtonTitle: .empty,
                buyerProtectionInfo: .initial
            )
            
            public init(title: String,
                        description: String,
                        moreInformationButtonTitle: String,
                        buyerProtectionInfo: ModalPopupContent)
            {
                self.title = title
                self.description = description
                self.moreInformationButtonTitle = moreInformationButtonTitle
                self.buyerProtectionInfo = buyerProtectionInfo
            }
        }
        
        public struct Benefits: Equatable {
            let sustainableShopping: String
            let itemsCurated: String
            let delivered: String
            
            static var initial = Self(
                sustainableShopping: .empty,
                itemsCurated: .empty,
                delivered: .empty)
            
            public init(sustainableShopping: String,
                        itemsCurated: String,
                        delivered: String)
            {
                self.sustainableShopping = sustainableShopping
                self.itemsCurated = itemsCurated
                self.delivered = delivered
            }
        }
        
        public struct ProductTitle: Equatable {
            let title: String
            let bidOffer: Int
            let currency: String
            let productDescriptionTextTitle: String
            let translateButtonTitle: String
            let description: String
            let sellerInfo: String
            @IgnoreEquatable
            var bidInfo: (Int) -> String
            @IgnoreEquatable
            var bidOfferTextTitle: (String) -> String
            @IgnoreEquatable
            var buyFromTextTitle: (String) -> String
            
            static var initial = Self(
                title: "",
                bidOffer: 0,
                currency: "",
                productDescriptionTextTitle: "",
                translateButtonTitle: "",
                description: "",
                sellerInfo: "",
                bidInfo: { _ in .empty },
                bidOfferTextTitle: { _ in .empty },
                buyFromTextTitle: { _ in .empty })
            
            public init(title: String,
                        bidOffer: Int,
                        currency: String,
                        productDescriptionTextTitle: String,
                        translateButtonTitle: String,
                        description: String,
                        sellerInfo: String,
                        bidInfo: @escaping (Int) -> String,
                        bidOfferTextTitle: @escaping (String) -> String,
                        buyFromTextTitle: @escaping (String) -> String)
            {
                self.title = title
                self.bidOffer = bidOffer
                self.currency = currency
                self.productDescriptionTextTitle = productDescriptionTextTitle
                self.translateButtonTitle = translateButtonTitle
                self.description = description
                self.sellerInfo = sellerInfo
                self.bidInfo = bidInfo
                self.bidOfferTextTitle = bidOfferTextTitle
                self.buyFromTextTitle = buyFromTextTitle
            }
        }
        
        ///TODO: Marko - Will be replaced soon
        public struct ProductDetails: Equatable {
            let title: String
            let colours: [String]
            let style: String
            let material: String
            let numberOfItems: String
            let labelPresent: String
            let width: String
            let depth: String
            let height: String
            let colourTitle: String
            let styleTitle: String
            let materialTitle: String
            let numberOfItemsTitle: String
            let labelPresentTitle: String
            let widthTitle: String
            let depthTitle: String
            let heightTitle: String

            static var initial = Self(
                title: "",
                colours: [""],
                style: "",
                material: "",
                numberOfItems: "",
                labelPresent: "",
                width: "",
                depth: "",
                height: "",
                colourTitle: "",
                styleTitle: "",
                materialTitle: "",
                numberOfItemsTitle: "",
                labelPresentTitle: "",
                widthTitle: "",
                depthTitle: "",
                heightTitle: ""
            )
            
            public init(title: String,
                        colours: [String],
                        style: String,
                        material: String,
                        numberOfItems: String,
                        labelPresent: String,
                        width: String,
                        depth: String,
                        height: String,
                        colourTitle: String,
                        styleTitle: String,
                        materialTitle: String,
                        numberOfItemsTitle: String,
                        labelPresentTitle: String,
                        widthTitle: String,
                        depthTitle: String,
                        heightTitle: String)
            {
                self.title = title
                self.colours = colours
                self.style = style
                self.material = material
                self.numberOfItems = numberOfItems
                self.labelPresent = labelPresent
                self.width = width
                self.depth = depth
                self.height = height
                self.colourTitle = colourTitle
                self.styleTitle = styleTitle
                self.materialTitle = materialTitle
                self.numberOfItemsTitle = numberOfItemsTitle
                self.labelPresentTitle = labelPresentTitle
                self.widthTitle = widthTitle
                self.depthTitle = depthTitle
                self.heightTitle = heightTitle
            }
        }
        
        public struct ProductCondition: Equatable {
            let mainConditionTitle: String
            let state: String
            let descriptions: [WhoppahModel.ProductQuality: String]
            let defects: [String]
            
            static var initial = Self(
                mainConditionTitle: "",
                state: "",
                descriptions: [:],
                defects: [""])
            
            public init(mainConditionTitle: String,
                        state: String,
                        descriptions: [WhoppahModel.ProductQuality: String],
                        defects: [String])
            {
                self.mainConditionTitle = mainConditionTitle
                self.state = state
                self.descriptions = descriptions
                self.defects = defects
            }
        }
        
        public struct ReviewsComponent: Equatable {
            let goBackButtonTitle: String
            
            static var initial = Self(goBackButtonTitle: "")
            
            public init(goBackButtonTitle: String)
            {
                self.goBackButtonTitle = goBackButtonTitle
            }
        }
        
        public struct RelatedProducts: Equatable {
            var newProductItems: [WhoppahModel.ProductTileItem]
            let headerTitle: String
            @IgnoreEquatable
            var bidFrom: (WhoppahModel.Price) -> String
            
            static var initial = Self(
                relatedProducts: [],
                headerTitle: "",
                bidFrom: { _ in return .empty })
            
            public init(relatedProducts: [WhoppahModel.ProductTileItem],
                        headerTitle: String,
                        bidFrom: @escaping (WhoppahModel.Price) -> String)
            {
                self.newProductItems = relatedProducts
                self.headerTitle = headerTitle
                self.bidFrom = bidFrom
            }
        }
        
        public struct ContactSupport: Equatable {
            let title: String
            let phoneNumber: String
            let supportEmail: String
            let contactComponents: [String]
            
            static var initial = Self(
                title: "",
                phoneNumber: "",
                supportEmail: "",
                contactComponents: [])
            
            public init(title: String,
                        phoneNumber: String,
                        supportEmail: String,
                        contactComponents: [String])
            {
                self.title = title
                self.phoneNumber = phoneNumber
                self.supportEmail = supportEmail
                self.contactComponents = contactComponents
            }
        }
        
        public struct SellerBoost: Equatable {
            let boostAdTitle: String
            let adPrice: String
            let adComponents: [String]
            let boostAdButtonTitle: String
            let currency: String
            
            static var initial = Self(
                boostAdTitle: "",
                adPrice: "",
                adComponents: [],
                boostAdButtonTitle: "",
                currency: "")
            
            public init(boostAdTitle: String,
                        adPrice: String,
                        adComponents: [String],
                        boostAdButtonTitle: String,
                        currency: String)
            {
                self.boostAdTitle = boostAdTitle
                self.adPrice = adPrice
                self.adComponents = adComponents
                self.boostAdButtonTitle = boostAdButtonTitle
                self.currency = currency
            }
        }
    }
}
