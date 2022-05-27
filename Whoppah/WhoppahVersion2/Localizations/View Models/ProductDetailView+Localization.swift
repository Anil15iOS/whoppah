//
//  ProductDetailView+Localization.swift
//  Whoppah
//
//  Created by Marko Stojkovic on 7.4.22..
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization
import WhoppahModel

extension ProductDetailView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
            
        let heroImage = HeroImageComponent(reportAdButtonTitle: l.ad_details_report_product(),
                                           reportUserButtonTitle: l.ad_details_report_user(),
                                           reportAdDescription: l.report_product_subtitle(),
                                           reportUserDescription: l.report_user_subtitle(),
                                           reportReason: l.report_user_reason(),
                                           reportDescriptionPlaceholder: l.report_user_description(),
                                           reportSubmissionSuccess: l.ad_details_report_success(),
                                           cancelButtonTitle: l.commonCancel(),
                                           sendButtonTitle: l.report_user_send(),
                                           doneButtonTitle: l.commonDone())
        
        let soldInfo = SoldInfo(title: l.pdpSoldFor(),
                                description: l.pdpSoldOutItem())
        
        //TODO: Marko - localize this static content
        let reservedInfo = ReservedInfo(title: "",
                                        description: "")
        
        let productTitle = ProductTitle(title: "",
                                        bidOffer: 0,
                                        currency: "",
                                        productDescriptionTextTitle: l.pdpProductDescriptionTitle(),
                                        translateButtonTitle: l.ad_details_description_section_translate(),
                                        description: "",
                                        sellerInfo: l.pdpSellerInfo(),
                                        bidInfo: { numBids in l.pdpBidInfo(numBids) },
                                        bidOfferTextTitle: { price in l.commonBidFromPrice(price) },
                                        buyFromTextTitle: { price in l.commonBuyNowPrice(price) })
        
        let sellerBoost = SellerBoost(boostAdTitle: l.pdpBoostAdTitle(),
                                      adPrice: "",
                                      adComponents: [l.pdpSellerBoostForJust(), l.pdpSellerBoostComplete()],
                                      boostAdButtonTitle: l.pdpBoostAdBtn(),
                                      currency: "")
        
        let productDetails = ProductDetails(title: l.ad_details_product_details(),
                                            colours: [""],
                                            style: "",
                                            material: "",
                                            numberOfItems: "",
                                            labelPresent: "",
                                            width: "",
                                            depth: "",
                                            height: "",
                                            colourTitle: l.ad_details_color_title(),
                                            styleTitle: l.search_filters_style(),
                                            materialTitle: l.commonMaterialTitle(),
                                            numberOfItemsTitle: l.number_of_items(),
                                            labelPresentTitle: l.pdpLabelPresent(),
                                            widthTitle: l.create_ad_main_dim_width(),
                                            depthTitle: l.create_ad_main_dim_depth(),
                                            heightTitle: l.create_ad_main_dim_height())
        
        let sellerComponent = SellerComponent(readReviewsButtonTitle: l.pdpReadAllReviews(),
                                              placeholder: l.question_form_text_field_placeholder(),
                                              image: nil,
                                              verifiedSeller: l.pdpVerifiedSeller(),
                                              rating: 0,
                                              showSellersItems: l.showAllSellerItems(),
                                              showMyItems: l.showAllMyItems())
        
        let productionConditionDescriptions: [WhoppahModel.ProductQuality: String] = [
            .good: l.conditionGoodDescription(),
            .great: l.conditionGreatDescription(),
            .perfect: l.conditionPerfectDescription()
        ]
        
        let productCondition = ProductCondition(mainConditionTitle: l.create_ad_main_condition_title(),
                                                state: "",
                                                descriptions: productionConditionDescriptions,
                                                defects: [""])
        
        let shippingInfo = ShippingInfo(shippingTitle: l.pdpDeliveryShipping(),
                                        shippingToTitle: l.productShippingFrom(),
                                        shipping: l.ad_details_shipment_section_title(),
                                        productPickupTitle: l.shippingProductPickup(),
                                        free: l.ad_details_delivery_pickup_price(),
                                        description: l.ad_details_shipping_tab_description(),
                                        shippingInfoTooltip: l.productShippingTooltipText(),
                                        showroomCity: l.commonShowroomCity())
        
        let buyerProtectionInfo = ModalPopupContent(
            title: l.pdpPopupBuyingProtectionTitle(),
            contentItems: [
                         ModalPopupContent.BulletPointItem(iconName: "green_check_icon", content: l.buyerProtectionUsp2()),
                         ModalPopupContent.BulletPointItem(iconName: "green_check_icon", content: l.buyerProtectionUsp3()),
                         ModalPopupContent.BulletPointItem(iconName: "green_check_icon", content: l.buyerProtectionUsp4()),
                         ModalPopupContent.BulletPointItem(iconName: "green_check_icon", content: l.buyerProtectionUsp5()),
                         ModalPopupContent.DividerItem(),
                         ModalPopupContent.ParagraphItem(title: l.pdpPopupBuyingProtectionSubtitle1(),
                               content: l.pdpPopupBuyingProtectionDescription1()),
                         ModalPopupContent.ParagraphItem(title: l.pdpPopupBuyingProtectionSubtitle2(),
                               content: l.pdpPopupBuyingProtectionDescription2())],
            goBackButtonTitle: l.pdpPopupGoBackToAd())
        
        let buyerProtection = BuyerProtection(
            title: l.buyerProtectionTitle(),
            description: l.pdpBuyerProtectionText(),
            moreInformationButtonTitle: l.readMore(),
            buyerProtectionInfo: buyerProtectionInfo)
        
        let benefits = Benefits(sustainableShopping: l.adDetailsSustainableShoppingTitle(),
                                itemsCurated: l.pdpBenefitsCurated(),
                                delivered: l.pdpBenefitsCourier())
        
        let relatedProducts = RelatedProducts(relatedProducts: [],
                                              headerTitle: l.similarItemsTitle(),
                                              bidFrom: { l.commonBidFromPrice($0.formattedString) })
        
        let contactSupport = ContactSupport(title: l.ad_details_contact_text_title(),
                                            phoneNumber: l.pdpContactPhoneNumber(),
                                            supportEmail: l.contactEmailTo(),
                                            contactComponents: [l.pdpContactBody(),
                                                                l.pdpContactPhone(),
                                                                l.contactEmailTo()])
        let review = ReviewsComponent(goBackButtonTitle: l.pdpPopupGoBackToAd())
        
        let biddingInfoContent = ModalPopupContent(
            title: l.pdpPopupBiddingTitle(),
            contentItems: [
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle1(),
                      content: l.pdpPopupBiddingDescription1()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle2(),
                      content: l.pdpPopupBiddingDescription2()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle3(),
                      content: l.pdpPopupBiddingDescription3()),
                ModalPopupContent.ParagraphItem(title: l.pdpPopupBiddingSubtitle4(),
                      content: l.pdpPopupBiddingDescription4())
            ],
            goBackButtonTitle: l.pdpPopupGoBackToAd())
        
        let bidConfirmationDialog = BidConfirmationDialog(
            title: l.pdpQuickBidModalTitle(),
            description: { bidAmount, productName in l.pdpQuickBidModalQuestionSure(bidAmount, productName) },
            confirmButtonTitle: l.pdpQuickBidModalPlaceBidBtn(),
            cancelButtonTitle: l.commonCancel())
        
        let bidComponent = BidComponent(bidPlaceholderText: l.placeBidTitle(),
                                        bidFromTitle: { priceString in l.commonBidFromPrice(priceString.formattedString) },
                                        placeBidButtontitle: l.adDetailsPlaceBidButton(),
                                        buyNowButtonTitle: { priceString in l.commonBuyNowPrice(priceString) },
                                        quickBidTitle: l.pdpQuickBid(),
                                        readMoreTitle: l.pdpReadMore(),
                                        biddingInfoPopup: biddingInfoContent,
                                        bidConfirmationDialog: bidConfirmationDialog)

        return .init(heroImageComponent: heroImage,
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
                     viewInAugmentedReality: l.adDetailsViewAr(),
                     userNotSignedInTitle: l.contextualSignupFavoritesTitle(),
                     userNotSignedInDescription: l.contextualSignupFavoritesDescription(),
                     product: nil)
    }
}
