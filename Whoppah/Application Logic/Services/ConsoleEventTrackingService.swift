//
//  ConsoleEventTrackingService.swift
//  Whoppah
//
//  Created by Dennis Ippel on 09/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahModel
import WhoppahDataStore

fileprivate var isLoggingEnabled: Bool = true

fileprivate func toConsole(_ message: String? = "", function: String = #function) {
    guard isLoggingEnabled else { return }
    print("👣 [TRACK] \(function) \(message ?? "")")
}

class ConsoleEventTrackingService: EventTrackingService {
    func trackAdViewed(product: WhoppahModel.Product) { toConsole(product.title) }
    func trackPhotoViewed(product: WhoppahModel.Product, photoID: UUID, isFullScreen: Bool) {
        toConsole(product.title)
    }
    func trackVideoViewed(product: WhoppahModel.Product, isFullScreen: Bool, page: PageSource) {
        toConsole(product.title)
    }
    
    func trackAdDetailsBuyNow(product: WhoppahModel.Product, categoryText: String, source: BuyNowSource) {
        toConsole(product.title)
    }
    
    func trackAdDetailsBid(product: WhoppahModel.Product, categoryText: String, maxBid: WhoppahModel.Price?, source: BidSource) {
        toConsole(product.title)
    }
    
    func trackBid(product: WhoppahModel.Product, bid: WhoppahModel.Price, source: BidSource) {
        toConsole(product.title)
    }
    
    func trackFavouriteStatusChanged(product: WhoppahModel.Product, status: Bool) {
        toConsole(product.title)
    }
    
    func trackLaunchedARView(product: WhoppahModel.Product) {
        toConsole(product.title)
    }
    
    func trackDismissedARView(product: WhoppahModel.Product, timeSpentSecs: Double) {
        toConsole(product.title)
    }
    
    var ad: AdEvents = ConsoleAdEvents()
    var filter: FilterEvents = ConsoleFilterEvents()
    var searchResults: SearchResultsEvents = ConsoleSearchResultsEvents()
    var home: HomeEvents = ConsoleHomeEvents()
    var createAd: CreateAdEvents = ConsoleCreateAdEvents()
    var usp: USPEvents = ConsoleUSPEvents()
    var searchByPhoto: SearchByPhotoEvents = ConsoleSearchByPhotoEvents()
    var appReview: AppReviewEvents = ConsoleAppReviewEvents()
    
    init(enableLogging: Bool) {
        isLoggingEnabled = enableLogging
    }
    
    func trackLogIn(authMethod: AuthenticationMethod, email: String?, userID: String, dataJoined: String) { toConsole("\(authMethod.rawValue) \(email ?? "")") }
    func trackEmailActivation() { toConsole() }
    func trackButtonClick(key: String, screen: String) { toConsole("\(key) \(screen)") }
    func trackSignUpStart() { toConsole() }
    func trackSignUpSuccess() { toConsole() }
    func trackProfileCompleted(isPhotoAdded: Bool, countryNumber: String?, phoneNumber: String?, postalCode: String?, country: String?) { toConsole() }
    func trackListStyleClicked(style: ListPresentation, page: PageSource) { toConsole(style.rawValue) }
    func trackAdViewed(ad: ProductDetails) { toConsole(ad.title) }
    func trackPhotoViewed(ad: ProductDetails, photoID: UUID, isFullScreen: Bool) { toConsole(ad.title) }
    func trackVideoViewed(ad: WhoppahCore.Product, isFullScreen: Bool, page: PageSource) { toConsole(ad.title) }
    func trackVideoViewed(ad: ProductDetails, isFullScreen: Bool, page: PageSource) { toConsole(ad.title) }
    func trackClickProduct(ad: WhoppahCore.Product, page: PageSource) { toConsole(ad.title) }
    func trackClickProduct(ad: WhoppahModel.ProductTileItem, page: PageSource) { toConsole(ad.title) }
    func trackAdDetailsBuyNow(ad: ProductDetails, categoryText: String, source: BuyNowSource) { toConsole(ad.title) }
    func trackBuyNowConfirmDialogClicked(adID: Int, price: Money) { toConsole("\(adID)") }
    func trackAdDetailsBid(ad: ProductDetails, categoryText: String, maxBid: Money?, source: BidSource) { toConsole(ad.title) }
    func trackBid(ad: ProductDetails, bid: Money, source: BidSource) { toConsole(ad.title) }
    func trackPay(adID: UUID, productCost: Money, transportType: TransportType, shippingCost: Money?, transactionCost: Money?, whoppahFee: Money?, totalCheckoutPrice: Money, isBuyNow: Bool) { toConsole("\(adID)") }
    func trackPlaceAd(userID: UUID, price: Money?, category: String?, isBrand: Bool, deliveryType: String?, photosCount: Int, hasVideo: Bool) { toConsole(userID.uuidString) }
    func trackAdUploaded(adID: UUID, userID: UUID, price: Money?, category: String, isBrand: Bool, deliveryType: String, photosCount: Int, hasVideo: Bool) { toConsole(adID.uuidString) }
    func trackFavouriteStatusChanged(ad: WhoppahCore.Product, status: Bool) { toConsole(ad.title) }
    func trackFavouriteStatusChanged(ad: ProductDetails, status: Bool) { toConsole(ad.title) }
    func trackFavoritesClicked() { toConsole() }
    func trackMyWhoppahClicked() { toConsole() }
    func trackChatsClicked() { toConsole() }
    func trackMyIncomeClicked() { toConsole() }
    func trackSendMessage(receiverID: UUID, adID: UUID, conversationID: UUID, counterBid: Double?, textMessage: Bool, isPDPQuestion: Bool) { toConsole(receiverID.uuidString) }
    func trackBidStatusChanged(receiverID: UUID, adID: UUID, conversationID: UUID, bidValue: Int, bidStatus: String) { toConsole(receiverID.uuidString) }
    func trackLaunchedARView(adID: UUID) { toConsole(adID.uuidString) }
    func dismissedARView(adID: UUID, timeSpentSecs: Double) { toConsole(adID.uuidString) }
    func trackAddedToCart(product: WhoppahModel.Product) { toConsole(product.id.uuidString) }
    func trackAddShippingInfo() { toConsole() }
    func trackAddPaymentInfo() { toConsole() }
    func trackBeginCheckout(source: CheckoutSource) { toConsole(source.rawValue) }
    func trackPurchase() { toConsole() }
}

private class ConsoleAdEvents: AdEvents {
    func trackShareClicked(product: WhoppahModel.Product) {
        toConsole(product.title)
    }
    
    func trackShareCompleted(product: WhoppahModel.Product, shareNetwork: String) {
        toConsole(product.title)
    }
    
    func trackShareClicked(ad: ProductDetails) { toConsole(ad.title) }
    func trackShareCompleted(ad: ProductDetails, shareNetwork: String) { toConsole(ad.title) }
    func trackShowAllSimilarItems(ad: ProductDetails) { toConsole(ad.title) }
    func trackSafeShoppingBannerClicked() { toConsole() }
}

private class ConsoleFilterEvents: FilterEvents {
    func trackFilterClicked(provider: SearchService) { toConsole(provider.searchText) }
}

private class ConsoleSearchResultsEvents: SearchResultsEvents {
    func trackSortClicked(type: WhoppahModel.SearchSort?, order: WhoppahModel.Ordering?) { toConsole("\(type?.rawValue ?? "") \(order?.rawValue ?? "")") }
    func trackFilterClicked() { toConsole() }
    func trackSearchScrolled(scrollDepth: Int) { toConsole() }
    func trackMapClicked() { toConsole() }
}

private class ConsoleHomeEvents: HomeEvents {
    func trackCategoryClicked(category: String) { toConsole(category) }
    func trackCategoryMenuClicked(category: String, product: String?) { toConsole("\(category) \(product?.titleKey ?? "")") }
    func trackClickedLook(name: String, page: PageSource) { toConsole(name) }
    func trackClickedNewAdsAll() { toConsole() }
    func trackClickedAllArtUnder1000() { toConsole() }
    func trackClickedSafeShoppingBanner() { toConsole() }
    func trackClickedUSPBanner(blockName: String) { toConsole() }
    func trackClickedSearchByPhoto() { toConsole() }
    func trackSearchPerformed(text: String) { toConsole() }
    func trackUSPCarouselScrolled(direction: String, blockName: String) { toConsole("\(direction) \(blockName)") }
    func trackTrendClicked(name: String) { toConsole(name) }
    func trackHighlightClicked(name: String) { toConsole(name) }
    func trackRandomScrolled(scrollDepth: Int) { toConsole() }
}

private class ConsoleCreateAdEvents: CreateAdEvents {
    func trackTipsAbandon() { toConsole() }
    func trackTipsPage1() { toConsole() }
    func trackTipsPage2() { toConsole() }
    func trackCancelAdCreation() { toConsole() }
    func trackBackPressedAdCreation() { toConsole() }
    func trackTakeNewPhotosClicked() { toConsole() }
    func trackCapturePhotoClicked() { toConsole() }
    func trackChooseExistingPhotosClicked() { toConsole() }
    func trackCreateVideoClicked() { toConsole() }
    func trackPhotoTooSmallError(sizeBytes: Int) { toConsole() }
    func trackVideoTooShort(lengthSeconds: Int) { toConsole() }
    func trackStartAdCreating(clickedPlaceAd: Bool) { toConsole() }
    func trackStartCreatingAd() { toConsole() }
    func trackCreateFirstAd() { toConsole() }
    func trackCreateAnotherAdInMyAds() { toConsole() }
    func trackCreateAnotherAdInDelete() { toConsole() }
    func trackCreateAnotherAdInConfirmation() { toConsole() }
    func trackFurnitureCategoryClicked() { toConsole() }
    func trackLightingCategoryClicked() { toConsole() }
    func trackArtCategoryClicked() { toConsole() }
    func trackDecorationCategoryClicked() { toConsole() }
    func trackBrandClicked() { toConsole() }
    func trackArtistClicked() { toConsole() }
    func trackDesignerClicked() { toConsole() }
    func trackMaterialClicked() { toConsole() }
    func trackBrandSaveClicked(brand: String) { toConsole(brand) }
    func trackArtistSaveClicked(artist: String) { toConsole(artist) }
    func trackDesignerSaveClicked(designer: String) { toConsole(designer) }
    func trackMaterialSaveClicked(materials: [AdAttribute]) { toConsole(materials.description) }
    func trackDescriptionNextClicked() { toConsole() }
    func trackPhotoNextClicked() { toConsole() }
    func trackVideoNextClicked() { toConsole() }
    func trackDetailsNextClicked() { toConsole() }
    func trackPriceNextClicked(price: Money) { toConsole(price.description) }
    func trackDeliveryNextClicked(location: Point?, deliveryType: String, cost: Money) { toConsole(deliveryType) }
    func trackSummaryAdjustPhotos() { toConsole() }
    func trackSummaryAdjustVideo() { toConsole() }
    func trackSummaryAdjustDescription() { toConsole() }
    func trackSummaryAdjustDetails() { toConsole() }
    func trackSummaryAdjustPrice() { toConsole() }
    func trackSummaryAdjustDelivery() { toConsole() }
    func trackDraftSave() { toConsole() }
    func trackDraftResume() { toConsole() }
}

private class ConsoleUSPEvents: USPEvents {
    func makeAdClicked() { toConsole() }
    func shopNowClicked() { toConsole() }
    func backClicked() { toConsole() }
}

private class ConsoleSearchByPhotoEvents: SearchByPhotoEvents {
    func trackClickedCamera() { toConsole() }
    func trackClickedGallery() { toConsole() }
    func trackClickedClose() { toConsole() }
}

private class ConsoleAppReviewEvents: AppReviewEvents {
    func trackSatisfiedClicked() { toConsole() }
    func trackNotSatisfiedClicked() { toConsole() }
    func trackAbandonReview() { toConsole() }
}
