//
//  ProductDetailView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import Foundation
import WhoppahModel

public extension ProductDetailView {
    enum TrackingAction {
        case trackFavouriteStatusChanged(product: Product, favorited: Bool)
        case trackSendMessage(receiverId: UUID,
                              productId: UUID,
                              conversationId: UUID)
        case trackBid(product: WhoppahModel.Product,
                      bid: WhoppahModel.Bid)
        case trackSafeShoppingBannerClicked
        case trackShareCompleted(product: WhoppahModel.Product,
                                 shareNetwork: String)
        case trackShareClicked(product: WhoppahModel.Product)
        case trackAdDetailsBuyNow(product: WhoppahModel.Product,
                                  categoryText: String)
        case trackAdDetailsBid(product: WhoppahModel.Product,
                               categoryText: String,
                               maxBid: Price)
        case trackAdViewed(product: WhoppahModel.Product)
        case trackPhotoViewed(product: WhoppahModel.Product,
                              photoId: UUID)
        case trackVideoViewed(product: WhoppahModel.Product)
        case trackLaunchedARView(product: WhoppahModel.Product)
        case trackDismissedARView(product: WhoppahModel.Product,
                                  timeSpentSecs: Double)
    }

    enum OutboundAction {
        case didTapCallNumber(phoneNumber: String)
        case didTapContactSupport(email: String,
                                  subject: String,
                                  body: String)
        case didTapBoostAd
        case openChat(id: UUID)
        case openCheckout(productId: UUID, bidId: UUID)
        case didTapShareProduct(product: WhoppahModel.Product)
        case didTapGoBack
        case showLoginModal(title: String,
                            description: String)
        case didReportError(error: Error)
        case didSelectProduct(id: UUID)
        case didTapShowMerchantProducts(id: UUID, merchantName: String)
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case fetchProduct(id: UUID)
        case fetchProductBySlug(slug: String)
        case didFinishFetchingProduct(Result<WhoppahModel.Product, Error>)
        case fetchRelatedItems(product: String)
        case didFinishFetchingRelatedItems(Result<[WhoppahModel.ProductTileItem], Error>)
        case createFavorite(productId: UUID)
        case didFinishCreatingFavorite(Result<FavoritedProduct, Error>)
        case removeFavorite(productId: UUID, favorite: Favorite)
        case didFinishRemovingFavorite(Result<FavoritedProduct, Error>)
        case sendProductMessage(product: WhoppahModel.Product, message: String)
        case didFinishSendingProductMessage(Result<UUID?, Error>)
        case buyNow(product: WhoppahModel.Product, amount: WhoppahModel.Price)
        case didFinishBuyNow(Result<WhoppahModel.Bid, Error>)
        case placeBid(product: WhoppahModel.Product, amount: WhoppahModel.Price)
        case didFinishPlaceBid(Result<WhoppahModel.Bid, Error>)
        case translate(text: String, language: WhoppahModel.Lang)
        case didFinishTranslating(Result<String, Error>)
        case fetchReviews(merchantId: UUID)
        case didFinishFetchingReviews(Result<[WhoppahModel.ProductReview], Error>)
        case didFinishReportingAbuse(Result<Bool, Error>)
        case reportAbuse(product: WhoppahModel.Product, type: AbuseReportType, reason: AbuseReportReason, description: String?)
    }
}

extension ProductDetailView.Action: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.loadContent, .loadContent):
            return true
        case (let .didFinishLoadingContent(lResult), let .didFinishLoadingContent(rResult)):
            return compare(lResult, rResult)
        case (let .trackingAction(lAction), let .trackingAction(rAction)):
            return lAction == rAction
        case (let .outboundAction(lAction), let .outboundAction(rAction)):
            return lAction == rAction
        case (let .fetchProduct(lId), let .fetchProduct(rId)):
            return lId == rId
        case (let .fetchProductBySlug(lSlug), let .fetchProductBySlug(rSlug)):
            return lSlug == rSlug
        case (let .didFinishFetchingProduct(lResult), let .didFinishFetchingProduct(rResult)):
            return compare(lResult, rResult)
        case (let .createFavorite(lProduct), let .createFavorite(rProduct)):
            return lProduct == rProduct
        case (let .removeFavorite(lProduct, lFavorite), let .removeFavorite(rProduct, rFavorite)):
            return lProduct == rProduct && lFavorite == rFavorite
        case (let .didFinishCreatingFavorite(lResult), let .didFinishCreatingFavorite(rResult)):
            return compare(lResult, rResult)
        case (let .didFinishRemovingFavorite(lResult), let .didFinishRemovingFavorite(rResult)):
            return compare(lResult, rResult)
        case (let .sendProductMessage(lProductId, lMessage), let .sendProductMessage(rProductId, rMessage)):
            return lProductId == rProductId && lMessage == rMessage
        case (let .didFinishSendingProductMessage(lResult), let .didFinishSendingProductMessage(rResult)):
            return compare(lResult, rResult)
        case (let .buyNow(lProduct, lAmount), let .buyNow(rProduct, rAmount)):
            return lProduct == rProduct && lAmount == rAmount
        case (let .didFinishBuyNow(lResult), let .didFinishBuyNow(rResult)):
            return compare(lResult, rResult)
        case (let .placeBid(lProduct, lAmount), let .placeBid(rProduct, rAmount)):
            return lProduct == rProduct && lAmount == rAmount
        case (let .didFinishPlaceBid(lResult), let .didFinishPlaceBid(rResult)):
            return compare(lResult, rResult)
        case (let .translate(lText, lLanguage), let .translate(rText, rLanguage)):
            return lText == rText && lLanguage == rLanguage
        case (let .didFinishTranslating(lResult), let .didFinishTranslating(rResult)):
            return compare(lResult, rResult)
        case (let .fetchReviews(lResult), let .fetchReviews(rResult)):
            return lResult == rResult
        case (let .didFinishFetchingReviews(lResult), let .didFinishFetchingReviews(rResult)):
            return compare(lResult, rResult)
        case (let .reportAbuse(lProduct, lType, lReason, lDescription), let .reportAbuse(rProduct, rType, rReason, rDescription)):
            return lProduct == rProduct && lType == rType && lReason == rReason && lDescription == rDescription
        case (let .didFinishReportingAbuse(lResult), let .didFinishReportingAbuse(rResult)):
            return compare(lResult, rResult)
        case (let .fetchRelatedItems(lProduct), let .fetchRelatedItems(rProduct)):
            return lProduct == rProduct
        default:
            return false
        }
    }
}

extension ProductDetailView.OutboundAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (let .didTapCallNumber(lPhoneNumber), let .didTapCallNumber(rPhoneNumber)):
            return lPhoneNumber == rPhoneNumber
        case (let .didTapContactSupport(lEmail, lSubject, lBody), let .didTapContactSupport(rEmail, rSubject, rBody)):
            return lEmail == rEmail && lSubject == rSubject && lBody == rBody
        case (let .openChat(lId), let .openChat(rId)):
            return lId == rId
        case (let .didTapShareProduct(lProduct), let .didTapShareProduct(rProduct)):
            return lProduct == rProduct
        case (let .openCheckout(lProduct, lBid), let .openCheckout(rProduct, rBid)):
            return lProduct == rProduct && lBid == rBid
        case (let .didTapShowMerchantProducts(lId, lName), let .didTapShowMerchantProducts(rId, rName)):
            return lId == rId && lName == rName
        case (let .showLoginModal(lTitle, lDescription), let .showLoginModal(rTitle, rDescription)):
            return lTitle == rTitle && lDescription == rDescription
        case (let .didReportError(lError), let .didReportError(rError)):
            return compare(lError, rError)
        case (.didTapBoostAd, .didTapBoostAd),
            (.didTapGoBack, .didTapGoBack):
            return true
        default:
            return false
        }
    }
}

extension ProductDetailView.TrackingAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        default:
            return false
        }
    }
}
