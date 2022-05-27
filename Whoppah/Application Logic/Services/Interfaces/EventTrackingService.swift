//
//  EventTrackingService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahModel
import WhoppahDataStore

enum UserRole: String {
    case personal
    case merchant
}

enum TransportType: String {
    case pickUp = "ophalen"
    case delivery = "bezorgen"
    case courier = "brenger_koerier_service"
}

enum PageSource: String {
    case search = "search_results"
    case favorites
    case home = "homepage"
    case looks
    case adDetails = "pdp"
    case profile = "public_profile"
    case adStats = "ad_stats"
}

enum BuyNowSource: String {
    case pdp = "PDP_View"
    case ar = "AR_View"
}

enum BidSource: String {
    case ar = "AR_View"
    case pdp = "PDP_View"
    case pdpNoBidYet = "PDP_NoBidYet"
}

enum CheckoutSource: String {
    case pdp = "PDP_view"
    case chatAcceptBid = "Chat_Accept_Bid"
    case chatBuyBow = "Chat_Buy_Now"
}

protocol EventTrackingService {
    var ad: AdEvents { get }
    var filter: FilterEvents { get }
    var searchResults: SearchResultsEvents { get }
    var home: HomeEvents { get }
    var createAd: CreateAdEvents { get }
    var usp: USPEvents { get }
    var searchByPhoto: SearchByPhotoEvents { get }
    var appReview: AppReviewEvents { get }

    func trackLogIn(authMethod: AuthenticationMethod, email: String?, userID: String, dataJoined: String)

    func trackEmailActivation()

    func trackButtonClick(key: String, screen: String)

    func trackSignUpStart()
    func trackSignUpSuccess()

    func trackProfileCompleted(isPhotoAdded: Bool, countryNumber: String?, phoneNumber: String?, postalCode: String?, country: String?)
    func trackListStyleClicked(style: ListPresentation, page: PageSource)

    func trackAdViewed(ad: ProductDetails)
    func trackAdViewed(product: WhoppahModel.Product)
    func trackPhotoViewed(ad: ProductDetails, photoID: UUID, isFullScreen: Bool)
    func trackPhotoViewed(product: WhoppahModel.Product, photoID: UUID, isFullScreen: Bool)

    func trackVideoViewed(ad: WhoppahCore.Product, isFullScreen: Bool, page: PageSource)
    func trackVideoViewed(product: WhoppahModel.Product, isFullScreen: Bool, page: PageSource)
    func trackVideoViewed(ad: ProductDetails, isFullScreen: Bool, page: PageSource)

    func trackClickProduct(ad: WhoppahCore.Product, page: PageSource)
    func trackClickProduct(ad: WhoppahModel.ProductTileItem, page: PageSource)

    func trackAdDetailsBuyNow(ad: ProductDetails, categoryText: String, source: BuyNowSource)
    func trackAdDetailsBuyNow(product: WhoppahModel.Product, categoryText: String, source: BuyNowSource)
    func trackBuyNowConfirmDialogClicked(adID: Int, price: Money)

    func trackAdDetailsBid(ad: ProductDetails, categoryText: String, maxBid: Money?, source: BidSource)
    func trackAdDetailsBid(product: WhoppahModel.Product, categoryText: String, maxBid: WhoppahModel.Price?, source: BidSource)
    func trackBid(ad: ProductDetails, bid: Money, source: BidSource)
    func trackBid(product: WhoppahModel.Product, bid: WhoppahModel.Price, source: BidSource)
    
    func trackAddedToCart(product: WhoppahModel.Product)
    func trackAddShippingInfo()
    func trackAddPaymentInfo()
    func trackBeginCheckout(source: CheckoutSource)
    func trackPurchase()

    func trackPay(adID: UUID, productCost: Money, transportType: TransportType, shippingCost: Money?, transactionCost: Money?, whoppahFee: Money?, totalCheckoutPrice: Money, isBuyNow: Bool)

    func trackPlaceAd(userID: UUID, price: Money?, category: String?, isBrand: Bool, deliveryType: String?, photosCount: Int, hasVideo: Bool)

    func trackAdUploaded(adID: UUID, userID: UUID, price: Money?, category: String, isBrand: Bool, deliveryType: String, photosCount: Int, hasVideo: Bool)
    func trackFavouriteStatusChanged(ad: WhoppahCore.Product, status: Bool)

    func trackFavouriteStatusChanged(ad: ProductDetails, status: Bool)
    func trackFavouriteStatusChanged(product: WhoppahModel.Product, status: Bool)
    func trackFavoritesClicked()

    func trackMyWhoppahClicked()
    func trackChatsClicked()
    func trackMyIncomeClicked()

    func trackSendMessage(receiverID: UUID, adID: UUID, conversationID: UUID, counterBid: Double?, textMessage: Bool, isPDPQuestion: Bool)

    func trackBidStatusChanged(receiverID: UUID, adID: UUID, conversationID: UUID, bidValue: Int, bidStatus: String)
    func trackLaunchedARView(product: WhoppahModel.Product)
    func trackDismissedARView(product: WhoppahModel.Product, timeSpentSecs: Double)
}

protocol AdEvents {
    func trackShareClicked(ad: ProductDetails)
    func trackShareClicked(product: WhoppahModel.Product)
    func trackShareCompleted(ad: ProductDetails, shareNetwork: String)
    func trackShareCompleted(product: WhoppahModel.Product, shareNetwork: String)
    func trackShowAllSimilarItems(ad: ProductDetails)
    func trackSafeShoppingBannerClicked()
}

protocol FilterEvents {
    func trackFilterClicked(provider: SearchService)
}

protocol SearchResultsEvents {
    func trackSortClicked(type: WhoppahModel.SearchSort?, order: WhoppahModel.Ordering?)
    func trackFilterClicked()
    func trackSearchScrolled(scrollDepth: Int)
    func trackMapClicked()
}

protocol HomeEvents {
    func trackCategoryClicked(category: String)
    func trackCategoryMenuClicked(category: String, product: String?)
    func trackClickedLook(name: String, page: PageSource)
    func trackClickedNewAdsAll()
    func trackClickedAllArtUnder1000()
    func trackClickedSafeShoppingBanner()
    func trackClickedUSPBanner(blockName: String)
    func trackClickedSearchByPhoto()
    func trackSearchPerformed(text: String)
    func trackUSPCarouselScrolled(direction: String, blockName: String)
    func trackTrendClicked(name: String)
    func trackHighlightClicked(name: String)
    func trackRandomScrolled(scrollDepth: Int)
}

protocol SearchByPhotoEvents {
    func trackClickedCamera()
    func trackClickedGallery()
    func trackClickedClose()
}

// Create ad
protocol CreateAdEvents {
    func trackTipsAbandon()
    func trackTipsPage1()
    func trackTipsPage2()

    func trackCancelAdCreation()
    func trackBackPressedAdCreation()
    func trackTakeNewPhotosClicked()
    func trackCapturePhotoClicked()
    func trackChooseExistingPhotosClicked()
    func trackCreateVideoClicked()
    func trackPhotoTooSmallError(sizeBytes: Int)
    func trackVideoTooShort(lengthSeconds: Int)

    func trackStartAdCreating(clickedPlaceAd: Bool)
    func trackStartCreatingAd()
    func trackCreateFirstAd()
    func trackCreateAnotherAdInMyAds()
    func trackCreateAnotherAdInDelete()
    func trackCreateAnotherAdInConfirmation()

    func trackFurnitureCategoryClicked()
    func trackLightingCategoryClicked()
    func trackArtCategoryClicked()
    func trackDecorationCategoryClicked()

    func trackBrandClicked()
    func trackArtistClicked()
    func trackDesignerClicked()
    func trackMaterialClicked()

    func trackBrandSaveClicked(brand: String)
    func trackArtistSaveClicked(artist: String)
    func trackDesignerSaveClicked(designer: String)
    func trackMaterialSaveClicked(materials: [AdAttribute])

    func trackDescriptionNextClicked()
    func trackPhotoNextClicked()
    func trackVideoNextClicked()
    func trackDetailsNextClicked()
    func trackPriceNextClicked(price: Money)
    func trackDeliveryNextClicked(location: Point?, deliveryType: String, cost: Money)

    func trackSummaryAdjustPhotos()
    func trackSummaryAdjustVideo()
    func trackSummaryAdjustDescription()
    func trackSummaryAdjustDetails()
    func trackSummaryAdjustPrice()
    func trackSummaryAdjustDelivery()

    func trackDraftSave()
    func trackDraftResume()
}

protocol AppReviewEvents {
    func trackSatisfiedClicked()
    func trackNotSatisfiedClicked()
    func trackAbandonReview()
}

protocol USPEvents {
    func makeAdClicked()
    func shopNowClicked()
    func backClicked()
}
