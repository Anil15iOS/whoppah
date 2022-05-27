//
//  EventTrackingServiceImpl.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Firebase
import Foundation
import WhoppahCore
import WhoppahModel
import Resolver
import WhoppahDataStore

typealias EventProps = [String: Any]
private class EventBuilder {
    private var _properties: EventProps
    var properties: EventProps {
        _properties
    }

    init(_ properties: inout EventProps, _ userService: LegacyUserService) {
        _properties = properties
        addLoggedIn(userService: userService)
    }

    init(_ userService: LegacyUserService) {
        _properties = EventProps()
        addLoggedIn(userService: userService)
    }

    init(_ userService: LegacyUserService, product: WhoppahCore.Product) {
        _properties = EventProps()
        addLoggedIn(userService: userService)
        addProductProperties(product)
    }
    
    init(_ userService: LegacyUserService, product: WhoppahModel.Product) {
        _properties = EventProps()
        addLoggedIn(userService: userService)
        addProductProperties(product)
    }

    init(_ userService: LegacyUserService, productDetails: ProductDetails) {
        _properties = EventProps()
        addLoggedIn(userService: userService)
        addProductProperties(productDetails: productDetails)
    }

    @discardableResult
    func addLoggedIn(userService: LegacyUserService) -> EventBuilder {
        _properties["logged_in"] = userService.isLoggedIn
        return self
    }

    @discardableResult
    func addProductProperties(_ ad: WhoppahCore.Product) -> EventBuilder {
        _properties["ad_id"] = ad.id.uuidString
        _properties["ad_name"] = ad.title
        _properties["ad_price"] = ad.price?.amount ?? ""
        _properties["has_video"] = !ad.video.isEmpty
        if let badge = ad.badge {
            _properties["ad_tag"] = badge.slug
        }
        _properties["is_favored"] = ad.isFavorite
        return self
    }
    
    @discardableResult
    func addProductProperties(_ ad: WhoppahModel.Product) -> EventBuilder {
        _properties["ad_id"] = ad.id.uuidString
        _properties["ad_name"] = ad.title
        _properties["ad_price"] = ad.auction?.buyNowPrice?.formattedString ?? ""
        _properties["has_video"] = ad.video != nil
        _properties["is_favored"] = ad.favorite != nil
        return self
    }
    
    @discardableResult
    func addProductProperties(_ ad: WhoppahModel.ProductTileItem) -> EventBuilder {
        _properties["ad_id"] = ad.id.uuidString
        _properties["ad_name"] = ad.title
        _properties["ad_price"] = ad.auction?.buyNowPrice ?? ""
        _properties["is_favored"] = ad.favorite != nil
        return self
    }

    @discardableResult
    func addProductProperties(productDetails: ProductDetails) -> EventBuilder {
        _properties["ad_id"] = productDetails.id.uuidString
        _properties["ad_name"] = productDetails.title
        _properties["ad_price"] = productDetails.price?.amount ?? ""
        _properties["ad_category"] = productDetails.categoryList.first?.slug ?? ""
        _properties["ad_brand"] = productDetails.brands.first?.slug ?? ""
        _properties["is_brand"] = !productDetails.brands.isEmpty
        _properties["has_video"] = !productDetails.productVideos.isEmpty
        if let badge = productDetails.badge {
            _properties["ad_tag"] = badge.slug
        }
        _properties["is_favored"] = productDetails.isFavorite
        return self
    }
}

struct Segment {
    func track(_ name: String, properties: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: properties)
    }
}

class EventHandler {
    fileprivate let segment: Segment
    @Injected fileprivate var userService: LegacyUserService

    fileprivate func event(_ name: String, _ props: EventProps? = nil) {
        if var props = props {
            Analytics.logEvent(name, parameters: EventBuilder(&props, userService).properties)
//            segment.track(name, properties: EventBuilder(&props, userService).properties)
        } else {
            Analytics.logEvent(name, parameters: EventBuilder(userService).properties)
        }
    }
    
    init(segment: Segment) {
        self.segment = segment
    }
}

class EventTrackingServiceImpl: EventHandler, EventTrackingService {
    lazy var ad: AdEvents = Ad(segment: segment)
    lazy var filter: FilterEvents = Filter(segment: segment)
    lazy var searchResults: SearchResultsEvents = SearchResults(segment: segment)
    lazy var home: HomeEvents = Home(segment: segment)
    lazy var searchByPhoto: SearchByPhotoEvents = SearchByPhoto(segment: segment)
    lazy var createAd: CreateAdEvents = CreateAd(segment: segment)
    lazy var appReview: AppReviewEvents = AppReview(segment: segment)
    lazy var usp: USPEvents = USP(segment: segment)

//    private func identify(token: AccessToken, email: String?) {
//        let userID = token.userID
//        let roleText = token.isMerchant ? UserRole.merchant.rawValue : UserRole.personal.rawValue
//        let anonymousID = segment.getAnonymousId()
//        if let email = email {
//            segment.identify("\(userID)", traits: ["email": email,
//                                                   "user_role": roleText,
//                                                   "userId": userID.uuidString,
//                                                   "anonymousId": anonymousID])
//
//        } else {
//            segment.identify("\(userID.uuidString)", traits: ["user_role": roleText,
//                                                              "userId": userID.uuidString,
//                                                              "anonymousId": anonymousID])
//        }
//    }

    func trackLogIn(authMethod: AuthenticationMethod, email: String?, userID: String, dataJoined: String) {
        segment.track("Clicked_LogIn", properties: ["auth_method": authMethod.rawValue,
                                                    "user_id": userID,
                                                    "date_joined": dataJoined])
//        identify(token: token, email: email)
    }

    func trackEmailActivation() {
        segment.track("Activated_SignUpEmail")
    }

    func trackButtonClick(key: String, screen: String) { event("Clicked_\(key)_In\(screen)") }

    func trackSignUpStart() {
        event("sign_up_start")
    }
    
    func trackSignUpSuccess() {
        event("sign_up")
    }

    func trackProfileCompleted(isPhotoAdded: Bool, countryNumber _: String?, phoneNumber: String?, postalCode: String?, country: String?) {
        let properties: EventProps = ["user_profilephoto": isPhotoAdded,
                                      "user_postalcode": postalCode ?? "",
                                      "user_telephonenumber": phoneNumber != nil ? 1 : 0,
                                      "user_country": country ?? ""]
        event("Completed_PersonalProfile", properties)
    }

    func trackListStyleClicked(style: ListPresentation, page: PageSource) {
        let properties: EventProps = ["view_type": style.rawValue,
                                      "screen_name": page.rawValue]
        event("Clicked_ChangePageView", properties)
    }

    func trackARLaunchClicked(ad: WhoppahCore.Product, page: PageSource) {
        var properties: EventProps = ["screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(ad)
        segment.track("Clicked_3D_InOverview", properties: builder.properties)
    }

    func trackAdViewed(ad: ProductDetails) {
        segment.track("Viewed_ProductDetailsPage", properties: EventBuilder(userService, productDetails: ad).properties)
    }
    
    func trackAdViewed(product: WhoppahModel.Product) {
        segment.track("Viewed_ProductDetailsPage", properties: EventBuilder(userService, product: product).properties)
    }

    func trackPhotoViewed(ad: ProductDetails, photoID: UUID, isFullScreen: Bool) {
        var properties: EventProps = ["photo_id": photoID.uuidString,
                                      "full_screen": isFullScreen]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Viewed_Photo", properties: builder.properties)
    }
    
    func trackPhotoViewed(product: WhoppahModel.Product, photoID: UUID, isFullScreen: Bool) {
        var properties: EventProps = ["photo_id": photoID.uuidString,
                                      "full_screen": isFullScreen]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Viewed_Photo", properties: builder.properties)
    }

    func trackVideoViewed(ad: WhoppahCore.Product, isFullScreen: Bool, page: PageSource) {
        var properties: EventProps = ["full_screen": isFullScreen,
                                      "screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(ad)
        segment.track("Viewed_Video", properties: builder.properties)
    }
    
    func trackVideoViewed(product: WhoppahModel.Product, isFullScreen: Bool, page: PageSource) {
        var properties: EventProps = ["full_screen": isFullScreen,
                                      "screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Viewed_Video", properties: builder.properties)
    }

    func trackVideoViewed(ad: ProductDetails, isFullScreen: Bool, page: PageSource) {
        var properties: EventProps = ["full_screen": isFullScreen,
                                      "screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Viewed_Video", properties: builder.properties)
    }

    func trackClickProduct(ad: WhoppahCore.Product, page: PageSource) {
        var properties: EventProps = ["screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(ad)
        segment.track("Clicked_ProductOrPrice_InOverview", properties: builder.properties)
    }
    
    func trackClickProduct(ad: WhoppahModel.ProductTileItem, page: PageSource) {
        var properties: EventProps = ["screen_name": page.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(ad)
        segment.track("Clicked_ProductOrPrice_InOverview", properties: builder.properties)
    }

    func trackAdDetailsBuyNow(ad: ProductDetails, categoryText: String, source: BuyNowSource) {
        var properties: EventProps = ["ad_category": categoryText,
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Clicked_BuyNow_InProductDetailsPage", properties: builder.properties)
    }
    
    func trackAdDetailsBuyNow(product: WhoppahModel.Product, categoryText: String, source: BuyNowSource) {
        var properties: EventProps = ["ad_category": categoryText,
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Clicked_BuyNow_InProductDetailsPage", properties: builder.properties)
    }

    func trackBuyNowConfirmDialogClicked(adID: Int, price: Money) {
        event("Clicked_BuyNow_InDialogueScreen", ["ad_id": adID, "ad_price": price])
    }

    func trackAdDetailsBid(ad: ProductDetails, categoryText: String, maxBid: Money?, source: BidSource) {
        var properties: EventProps = ["ad_category": categoryText,
                                      "highest_bid": maxBid ?? "",
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Clicked_Bid_InProductDetailsPage", properties: builder.properties)
    }
    
    func trackAdDetailsBid(product: WhoppahModel.Product, categoryText: String, maxBid: WhoppahModel.Price?, source: BidSource) {
        var properties: EventProps = ["ad_category": categoryText,
                                      "highest_bid": maxBid ?? "",
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Clicked_Bid_InProductDetailsPage", properties: builder.properties)
    }

    func trackBid(ad: ProductDetails, bid: Money, source: BidSource) {
        var properties: EventProps = ["bid_price": bid,
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Clicked_Bid_InDialogueScreen", properties: builder.properties)
    }
    
    func trackBid(product: WhoppahModel.Product, bid: WhoppahModel.Price, source: BidSource) {
        var properties: EventProps = ["bid_price": bid.formattedString,
                                      "source": source.rawValue]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Clicked_Bid_InDialogueScreen", properties: builder.properties)
    }

    func trackPay(adID: UUID, productCost: Money, transportType: TransportType, shippingCost: Money?, transactionCost: Money?, whoppahFee: Money?, totalCheckoutPrice: Money, isBuyNow: Bool) {
        var properties: EventProps = ["ad_id": adID.uuidString,
                                      "product_cost": productCost,
                                      "transport_type": transportType.rawValue,
                                      "is_buynow": isBuyNow,
                                      "shipping_cost": shippingCost ?? 0,
                                      "transaction_cost": transactionCost ?? 0,
                                      "whoppah_fee": whoppahFee ?? 0,
                                      "total_checkout_price": totalCheckoutPrice]
        segment.track("Clicked_Pay", properties: EventBuilder(&properties, userService).properties)
    }
    
    func trackAddedToCart(product: WhoppahModel.Product) {
        var properties: EventProps = ["ad_id": product.id.uuidString]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("add_to_cart", properties: builder.properties)
    }
    
    func trackAddShippingInfo() {
        segment.track("add_shipping_info")
    }
    
    func trackAddPaymentInfo() {
        segment.track("add_payment_info")
    }
    
    func trackBeginCheckout(source: CheckoutSource) {
        let properties: EventProps = ["source": source.rawValue]
        segment.track("begin_checkout", properties: properties)
    }
    
    func trackPurchase() {
        segment.track("purchase")
    }

    func trackPlaceAd(userID: UUID, price: Money?, category: String?, isBrand: Bool, deliveryType: String?, photosCount: Int, hasVideo: Bool) {
        var properties: EventProps = ["created_by": userID.uuidString,
                                      "is_brand": isBrand,
                                      "photos_count": photosCount,
                                      "product_category": category ?? "",
                                      "delivery_type": deliveryType ?? "",
                                      "product_price": price ?? "",
                                      "has_videos": hasVideo]
        segment.track("Clicked_PlaceAd", properties: EventBuilder(&properties, userService).properties)
    }

    func trackAdUploaded(adID: UUID, userID: UUID, price: Money?, category: String, isBrand: Bool, deliveryType: String, photosCount: Int, hasVideo: Bool) {
        var properties: EventProps = ["ad_id": adID.uuidString,
                                      "created_by": userID.uuidString,
                                      "product_price": price ?? "",
                                      "product_category": category,
                                      "is_brand": isBrand,
                                      "delivery_type": deliveryType,
                                      "photos_count": photosCount,
                                      "has_videos": hasVideo]

        segment.track("Confirmed_AdUploaded", properties: EventBuilder(&properties, userService).properties)
    }

    func trackFavouriteStatusChanged(ad: WhoppahCore.Product, status: Bool) {
        var properties: EventProps = ["favorite_status": status]
        let builder = EventBuilder(&properties, userService).addProductProperties(ad)
        segment.track("Changed_FavoriteStatus", properties: builder.properties)
    }
    
    func trackFavouriteStatusChanged(product: WhoppahModel.Product, status: Bool) {
        var properties: EventProps = ["favorite_status": status]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Changed_FavoriteStatus", properties: builder.properties)
    }

    func trackFavouriteStatusChanged(ad: ProductDetails, status: Bool) {
        var properties: EventProps = ["favorite_status": status]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Changed_FavoriteStatus", properties: builder.properties)
    }

    func trackFavoritesClicked() { event("Clicked_FavoritesOverview") }

    // My Whoppah

    func trackMyWhoppahClicked() { event("Viewed_Ads_InMyAds") }
    func trackChatsClicked() { event("Clicked_ChatsOverview") }
    func trackMyIncomeClicked() { event("Viewed_MyIncome") }

    func trackSendMessage(receiverID: UUID, adID: UUID, conversationID: UUID, counterBid: Double?, textMessage: Bool, isPDPQuestion: Bool) {
        var properties: EventProps = ["receiver_id": receiverID.uuidString,
                                      "ad_id": adID.uuidString,
                                      "conversation_id": conversationID.uuidString,
                                      "counter_bid": counterBid ?? 0.0,
                                      "text_message": textMessage,
                                      "is_PDP_question": isPDPQuestion]

        segment.track("Sent_Message_InChat", properties: EventBuilder(&properties, userService).properties)
    }

    func trackBidStatusChanged(receiverID: UUID, adID: UUID, conversationID: UUID, bidValue: Int, bidStatus: String) {
        var properties: EventProps = ["receiver_id": receiverID.uuidString,
                                      "ad_id": adID.uuidString,
                                      "conversation_id": conversationID.uuidString,
                                      "bid_value": bidValue,
                                      "bid_status": bidStatus]

        segment.track("Changed_BidStatus", properties: EventBuilder(&properties, userService).properties)
    }
    
    func trackLaunchedARView(product: WhoppahModel.Product) {
        var properties: EventProps = ["ad_id": product.id.uuidString]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Launched_ARView", properties: builder.properties)
    }
    
    func trackDismissedARView(product: WhoppahModel.Product, timeSpentSecs: Double) {
        var properties: EventProps = ["ad_id": product.id.uuidString, "time_spent_secs": timeSpentSecs]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Dismissed_ARView", properties: builder.properties)
    }
}

private class Home: EventHandler, HomeEvents {
    func trackCategoryMenuClicked(category: String, product: String?) {
        let properties: EventProps = ["ad_category": category,
                                      "ad_product_type": product ?? ""]

        event("Clicked_Category_ViaHamburgerMenu", properties)
    }

    func trackClickedLook(name: String, page: PageSource) {
        let properties: EventProps = ["shopdelook_category": name,
                                      "screen_name": page.rawValue]
        event("Clicked_ShopDeLook", properties)
    }

    func trackCategoryClicked(category: String) { event("Clicked_Category_AtTopOfHomepage", ["ad_category": category]) }
    func trackClickedNewAdsAll() { event("Clicked_AllNieuwOpWhoppah") }
    func trackClickedAllArtUnder1000() { event("Clicked_AllArtUnder1000") }
    func trackClickedSafeShoppingBanner() { event("Clicked_ZoWerktBanner_InHomepage") }
    func trackClickedSearchByPhoto() { event("Started_SearchByPhoto") }
    func trackClickedUSPBanner(blockName: String) { event("Clicked_GuaranteeBanner_InHomepage", ["block_name": blockName]) }
    func trackSearchPerformed(text: String) { event("Clicked_SearchTextBar", ["search_text": text]) }
    func trackUSPCarouselScrolled(direction: String, blockName: String) { event("Scrolled_GuaranteeBanner_InHomepage", ["scroll_direction": direction, "block_name": blockName]) }
    func trackTrendClicked(name: String) { event("Clicked_Trend_InHomepage", ["trend_name": name]) }
    func trackHighlightClicked(name: String) { event("Clicked_HighlightsBlock_InHomepage", ["block_name": name]) }
    func trackRandomScrolled(scrollDepth: Int) { event("Scrolled_AndMuchMore_InHomepage", ["scroll_depth": scrollDepth]) }
}

private class SearchByPhoto: EventHandler, SearchByPhotoEvents {
    func trackClickedCamera() { event("Clicked_Camera_InSearchByPhoto") }
    func trackClickedGallery() { event("Clicked_Gallery_InSearchByPhoto") }
    func trackClickedClose() { event("Clicked_X_InSearchByPhoto") }
}

private class SearchResults: EventHandler, SearchResultsEvents {
    func trackSortClicked(type: WhoppahModel.SearchSort?, order: WhoppahModel.Ordering?) {
        var properties: EventProps = ["sort_type": type?.rawValue ?? "",
                                      "sort_order": order?.rawValue ?? ""]
        segment.track("Clicked_Sort", properties: EventBuilder(&properties, userService).properties)
    }

    func trackFilterClicked() { event("Clicked_Filter_InOverview") }
    func trackMapClicked() { event("Clicked_Map_InOverview") }

    func trackSearchScrolled(scrollDepth: Int) {
        var properties: EventProps = ["scroll_depth": scrollDepth]
        segment.track("Scrolled_SearchResults", properties: EventBuilder(&properties, userService).properties)
    }
}

// Create ad
private class CreateAd: EventHandler, CreateAdEvents {
    func trackTipsAbandon() { event("Abandoned_Tips") }
    func trackTipsPage1() { event("Viewed_TipsPage1") }
    func trackTipsPage2() { event("Viewed_TipsPage2") }

    func trackStartAdCreating(clickedPlaceAd: Bool) {
        var properties: EventProps = ["clicked_plaatseenadvertentie": clickedPlaceAd]
        segment.track("Started_AdCreation", properties: EventBuilder(&properties, userService).properties)
    }

    func trackStartCreatingAd() { segment.track("Clicked_StartCreatingAd") }
    func trackCreateFirstAd() { segment.track("Clicked_CreateFirstAd_inWelcomeDS") }
    func trackCreateAnotherAdInMyAds() { segment.track("Clicked_CreateAd_InMyAds") }
    func trackCreateAnotherAdInDelete() { segment.track("Clicked_CreateAd_InDeleteAdDS") }
    func trackCreateAnotherAdInConfirmation() { segment.track("Clicked_CreateAnotherAd_InAdConfirmationScreen") }
    func trackCancelAdCreation() { event("abandoned_AdCreation") }
    func trackBackPressedAdCreation() { event("Clicked_Back_InJeAdvertentie") }
    func trackCapturePhotoClicked() { event("Clicked_CapturePhoto_InCameraScreen") }
    func trackTakeNewPhotosClicked() { event("Clicked_TakeNewPhotos_InAdCreation_PhotoSection") }
    func trackChooseExistingPhotosClicked() { event("Clicked_ChooseExistingPhotos_InAdCreation_PhotoSection") }
    func trackBrandClicked() { event("Clicked_Brand_InAdCreation_DetailsSection") }
    func trackArtistClicked() { event("Clicked_Artist_InAdCreation_DetailsSection") }
    func trackDesignerClicked() { event("Clicked_Designer_InAdCreation_DetailsSection") }
    func trackMaterialClicked() { event("Clicked_Material_InAdCreation_DetailsSection") }
    func trackMaterialSaveClicked(materials: [AdAttribute]) {
        let properties: EventProps = ["ad_material_1": materials.first?.slug ?? "",
                                      "ad_material_2": materials.count > 1 ? materials[1].slug : "",
                                      "ad_material_3": materials.count > 2 ? materials[2].slug : ""]

        event("Clicked_SaveMaterial_InAdCreation_DetailsSection", properties)
    }

    func trackFurnitureCategoryClicked() { event("Clicked_Furniture_InAdCreation") }
    func trackLightingCategoryClicked() { event("Clicked_Lighting_InAdCreation") }
    func trackArtCategoryClicked() { event("Clicked_Art_InAdCreation") }
    func trackDecorationCategoryClicked() { event("Clicked_Decoration_InAdCreation") }

    func trackBrandSaveClicked(brand: String) { event("Clicked_SaveBrand_InAdCreation_DetailsSection", ["ad_brand": brand]) }
    func trackArtistSaveClicked(artist: String) { event("Clicked_SaveArtist_InAdCreation_DetailsSection", ["ad_artist": artist]) }

    func trackDesignerSaveClicked(designer: String) { event("Clicked_Save_InDesignerSelection", ["ad_designer": designer]) }

    func trackPhotoTooSmallError(sizeBytes: Int) { event("Photo_TooSmall_InCameraScreen", ["size_bytes": sizeBytes]) }

    func trackVideoTooShort(lengthSeconds: Int) { event("Video_TooShort_InCameraScreen", ["length_seconds": lengthSeconds]) }

    func trackCreateVideoClicked() { event("Clicked_CreateNewVideo_InAdCreation_VideoSection") }

    func trackDeliveryNextClicked(location: Point?, deliveryType: String, cost: Money) {
        let location = location != nil ? [location!.longitude, location!.latitude] : [0.0, 0.0]
        var properties: EventProps = ["delivery_type": deliveryType,
                                      "shipping_cost": cost,
                                      "product_location": location]

        segment.track("Clicked_ViewSummary_InAdCreation_DeliverySection", properties: EventBuilder(&properties, userService).properties)
    }

    func trackDescriptionNextClicked() { event("Clicked_Next_InAdCreation_DescriptionSection") }
    func trackPhotoNextClicked() { event("Clicked_NextStep_InAdCreation_PhotoSection") }
    func trackVideoNextClicked() { event("Clicked_NextStep_InAdCreation_VideoSection") }
    func trackDetailsNextClicked() { event("Clicked_NextStep_InAdCreation_DetailsSection") }
    func trackPriceNextClicked(price: Money) { event("Clicked_NextStep_InAdCreation_PriceSection", ["product_price": price]) }

    func trackSummaryAdjustPhotos() { event("Clicked_AdjustPhotos_InAdCreation_SummarySection") }
    func trackSummaryAdjustVideo() { event("Clicked_AdjustVideo_InAdCreation_SummarySection") }
    func trackSummaryAdjustDescription() { event("Clicked_AdjustDesc_InAdCreation_SummarySection") }
    func trackSummaryAdjustDetails() { event("Clicked_AdjustDetails_InAdCreation_SummarySection") }
    func trackSummaryAdjustPrice() { event("Clicked_AdjustPrice_InAdCreation_SummarySection") }
    func trackSummaryAdjustDelivery() { event("Clicked_AdjustDelivery_InAdCreation_SummarySection") }

    func trackDraftSave() {
        segment.track("Clicked_SaveDraft_InAdCreation")
    }

    func trackDraftResume() {
        segment.track("Clicked_ResumeDraft_InAdCreation")
    }
}

private class AppReview: EventHandler, AppReviewEvents {
    func trackSatisfiedClicked() { event("Clicked_Satisfied_InLeaveReviewDS") }
    func trackNotSatisfiedClicked() { event("Clicked_NotSatisfied_InLeaveReviewDS") }
    func trackAbandonReview() { event("Clicked_Abandon_InLeaveReviewDS") }
}

private class Ad: EventHandler, AdEvents {
    func trackShareClicked(ad: ProductDetails) {
        let builder = EventBuilder(userService, productDetails: ad)
        segment.track("Clicked_Share", properties: builder.properties)
    }
    
    func trackShareClicked(product: WhoppahModel.Product) {
        let builder = EventBuilder(userService, product: product)
        segment.track("Clicked_Share", properties: builder.properties)
    }

    func trackShareCompleted(ad: ProductDetails, shareNetwork: String) {
        var properties: EventProps = ["sharing_network": shareNetwork]
        let builder = EventBuilder(&properties, userService).addProductProperties(productDetails: ad)
        segment.track("Completed_Share", properties: builder.properties)
    }

    func trackShareCompleted(product: WhoppahModel.Product, shareNetwork: String) {
        var properties: EventProps = ["sharing_network": shareNetwork]
        let builder = EventBuilder(&properties, userService).addProductProperties(product)
        segment.track("Completed_Share", properties: builder.properties)
    }
    
    func trackARLaunchFromButton(ad: ProductDetails) {
        segment.track("Clicked_3D_InProductDetailsPage", properties: EventBuilder(userService, productDetails: ad).properties)
    }

    func trackARLaunchFromBanner(ad: ProductDetails) {
        segment.track("Clicked_3Dbanner_InProductDetailsPage", properties: EventBuilder(userService, productDetails: ad).properties)
    }

    func trackShowAllSimilarItems(ad: ProductDetails) {
        let builder = EventBuilder(userService, productDetails: ad)
        segment.track("Clicked_AllFitsWellWith_InProductDetailsPage", properties: builder.properties)
    }

    func trackSafeShoppingBannerClicked() { event("Clicked_ShoppenIsVeiligBanner_InProductDetailsPage") }
}

private class Filter: EventHandler, FilterEvents {
    func trackFilterClicked(provider: SearchService) {
        var quality = ""

        if let selectedQuality = provider.quality {
            switch selectedQuality {
            case GraphQL.ProductQuality.good:
                quality = "good"
            case GraphQL.ProductQuality.great:
                quality = "very_good"
            case GraphQL.ProductQuality.perfect:
                quality = "excellent"
            default: break
            }
        }

        let radiusValue = provider.radiusKilometres

        var properties: EventProps = ["search_text": provider.searchText ?? "",
                                      "price_from": provider.minPrice ?? "",
                                      "price_to": provider.maxPrice ?? "",
                                      "location_radius": radiusValue ?? "",
                                      "ad_categories": provider.categories.map { $0.slug },
                                      "minimal_condition": quality]
        segment.track("Clicked_Filter_InFilterPage", properties: EventBuilder(&properties, userService).properties)
    }
}

private class USP: EventHandler, USPEvents { // swiftlint:disable:this type_name
    func makeAdClicked() { event("Clicked_MakeAd_ViaUSP") }
    func shopNowClicked() { event("Clicked_ShopNow_ViaUSP") }
    func backClicked() { event("Clicked_Back_ViaUSP") }
}
