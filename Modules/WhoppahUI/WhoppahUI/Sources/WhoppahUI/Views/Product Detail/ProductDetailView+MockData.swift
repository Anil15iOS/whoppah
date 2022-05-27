//  
//  ProductDetailView+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import Foundation
import WhoppahModel

public extension ProductDetailView.Model {
    static var mock: Self {
        
        let heroImageComponent = HeroImageComponent(reportAdButtonTitle: "Report ad",
                                                    reportUserButtonTitle: "Report behaviour",
                                                    reportAdDescription: "We will dive into your report as soon as possible",
                                                    reportUserDescription: "We will dive into your report as soon as possible",
                                                    reportReason: "Reason",
                                                    reportDescriptionPlaceholder: "Description",
                                                    reportSubmissionSuccess: "Thank you for reporting.",
                                                    cancelButtonTitle: "Cancel",
                                                    sendButtonTitle: "Send",
                                                    doneButtonTitle: "DONE")
        
        let soldInfo = SoldInfo(title: "SOLD for",
                                description: "Oh no, you missed this one! It is already sold. We do have more amazing items available, but be quick!")
        
        let reservedInfo = ReservedInfo(title: "This item is reserved",
                                        description: "This item has a deal pending with the seller.")
        
        let sellerInfo = "You are the seller of this item. Remember: you can’t buy or bid on your own ads"
        
        let bidInfo: (Int) -> String = { numBids in "There are \(numBids) bids on this item now" }
        let bidOfferTextTitle: (String) -> String = { price in "Bid from \(price)" }
        let buyFromTextTitle: (String) -> String = { price in "Buy for \(price)" }
        
        let productTitle = ProductTitle(title: "Joe columbo Elda chair in blue velours",
                                        bidOffer: 6000,
                                        currency: "€",
                                        productDescriptionTextTitle: "Product description",
                                        translateButtonTitle: "Translate",
                                        description: "It was constructed from steel and linoleum. The table top made of ecological linoleum framed in steel gives the table an elegant appearance. The graphic lines and well-proportioned table plate create a harmonious overall picture.",
                                        sellerInfo: sellerInfo,
                                        bidInfo: bidInfo,
                                        bidOfferTextTitle: bidOfferTextTitle,
                                        buyFromTextTitle: buyFromTextTitle)
        
        let sellerBoost = SellerBoost(boostAdTitle: "Boost your ad!",
                                      adPrice: "99,9",
                                      adComponents: ["For just",
                                                     "you can boost your ad to the top of the category increase your chances of selling faster!"],
                                      boostAdButtonTitle: "Boost this ad!",
                                      currency: "€")
        
        let productDetails = ProductDetails(title: "Product details",
                                            colours: ["E26F77", "969FAA"],
                                            style: "Vintage",
                                            material: "Metal, Linoleum",
                                            numberOfItems: "3 pcs",
                                            labelPresent: "Yes",
                                            width: "58 cm",
                                            depth: "35 cm",
                                            height: "89 cm",
                                            colourTitle: "Colour",
                                            styleTitle: "Style",
                                            materialTitle: "Material",
                                            numberOfItemsTitle: "Number of items",
                                            labelPresentTitle: "Label present",
                                            widthTitle: "Width",
                                            depthTitle: "Depth",
                                            heightTitle: "Height"
        )
        
        let sellerComponent = SellerComponent(readReviewsButtonTitle: "Read all reviews",
                                              placeholder: "Ask a question",
                                              image: nil,
                                              verifiedSeller: "Verified seller",
                                              rating: 3.9,
                                              showSellersItems: "Show all seller's items",
                                              showMyItems: "Show all my items")
        
        let productionConditionDescriptions: [WhoppahModel.ProductQuality: String] = [
            .good: "In good condition with slight traces of use, appropriate to the age of the item",
            .great: "In a very good condition with minimal traces of use",
            .perfect: "Condition is as good as new without traces of use"
        ]
        
        let productCondition = ProductCondition(mainConditionTitle: "Condition",
                                                state: "Very good",
                                                descriptions: productionConditionDescriptions,
                                                defects: ["Rust",
                                                          "Stains",
                                                          "Discoloring"])
        
        let shippingInfo = ShippingInfo(shippingTitle: "Delivery & Shipping",
                                        shippingToTitle: "From:",
                                        shipping: "Shipping",
                                        productPickupTitle: "Pickup the item in:",
                                        free: "Free",
                                        description: "You choose the shipping method (enabled by the seller) at checkout. The costs are added to the total amount. If you choose the courier, you will be contacted after payment to plan the delivery.",
                                        shippingInfoTooltip: "Select your country to see the delivery price",
                                        showroomCity: "Utrecht")
        
        let buyerProtectionInfo = ModalPopupContent(
            title: "Buyer protection",
            contentItems: [ModalPopupContent.ParagraphItem(title: "Title", content: "Content")],
            goBackButtonTitle: "Go back to ad")
        
        let buyerProtection = BuyerProtection(
            title: "Buyer protection",
            description: "Go for safe shopping! Not happy with the purchase or different than advertised? We got you covered with the buyer protection. This includes:",
            moreInformationButtonTitle: "Read more",
            buyerProtectionInfo: buyerProtectionInfo)
        
        let benefits = Benefits(sustainableShopping: "Sustainable shopping",
                                itemsCurated: "All items curated by Whoppah",
                                delivered: "Delivered by Whoppah courier")
        
        let relatedProducts = RelatedProducts(relatedProducts: [.random,
                                                                .random],
                                              headerTitle: "New in",
                                              bidFrom: { "Bid from \($0.formattedString)" })
        
        let contactSupport = ContactSupport(title: "Heb je een vraag?",
                                            phoneNumber: "+31202444693",
                                            supportEmail: "support@whoppah.com",
                                            contactComponents: [
                                                "Whoppah is van maandag tot en met vrijdag bereikbaar tijdens kantooruren op:",
                                                "+31 (0) 20 244 46 93",
                                                "support@whoppah.com"])
        
        let review = ReviewsComponent(goBackButtonTitle: "Go back to the product")
        
        let biddingInfoContent = ModalPopupContent(
            title: "This is how bidding works",
            contentItems: [
                ModalPopupContent.ParagraphItem(title: "A bid is valid for 48 hours",
                      content: "The seller can accept your offer or make a counter proposal."),
                ModalPopupContent.ParagraphItem(title: "Negotiate via the chat",
                      content: "You can check your bid in the chat with the seller. Go to My Chats & Bids to view them."),
                ModalPopupContent.ParagraphItem(title: "Counter offer",
                      content: "You can place a counter offer at the bottom of the chat with the seller."),
                ModalPopupContent.ParagraphItem(title: "Deal is deal",
                      content: "If the seller accepts your offer, a payment button will appear in the chat that will lead you to the checkout where you can choose your transport option and make the payment.")
            ],
            goBackButtonTitle: "Go back to the product")
        
        let bidConfirmationDialog = BidConfirmationDialog(
            title: "You are about to place a bid",
            description: { bidAmount, productName in "Are you sure you want to place a bid for \(bidAmount) on \(productName)?" },
            confirmButtonTitle: "Yes, place my bid",
            cancelButtonTitle: "Cancel")
        
        let bidComponent = BidComponent(bidPlaceholderText: "Your bid",
                                        bidFromTitle: { priceString in "Bid from \(priceString)" },
                                        placeBidButtontitle: "Place bid",
                                        buyNowButtonTitle: { priceString in "Buy now for \(priceString)" },
                                        quickBidTitle: "Quick bid",
                                        readMoreTitle: "Read more about how bidding works",
                                        biddingInfoPopup: biddingInfoContent,
                                        bidConfirmationDialog: bidConfirmationDialog)
        
        return Self(
            heroImageComponent: heroImageComponent,
            soldInfo: soldInfo,
            reservedInfo: reservedInfo,
            productTitle: productTitle,
            sellerBoost: sellerBoost,
            productDetails: productDetails,
            sellerComponent: sellerComponent,
            productCondition: productCondition,
            shippingInfo: shippingInfo,
            buyerProtection: buyerProtection,
            benefits: benefits,
            relatedProducts: relatedProducts,
            contactSupport: contactSupport,
            review: review,
            bidComponent: bidComponent,
            viewInAugmentedReality: "View item in your room",
            userNotSignedInTitle: "Please sign in",
            userNotSignedInDescription: "Sign in description",
            product: .random)
    }
}
