//  
//  MerchantProductsView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import Foundation
import WhoppahModel

public extension MerchantProductsView {
    enum TrackingAction: Equatable {}

    enum OutboundAction {
        case didSelectProduct(id: UUID)
        case didTapGoBack
        case showLoginModal(title: String,
                            description: String)
        case didReportError(error: Error)
    }

    enum Action {
        case loadContent(merchantId: UUID, merchantName: String)
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case createFavorite(productId: UUID)
        case didFinishCreatingFavorite(Result<FavoritedProduct, Error>)
        case removeFavorite(productId: UUID, favorite: Favorite)
        case didFinishRemovingFavorite(Result<FavoritedProduct, Error>)
        case fetchProducts(merchantId: UUID)
        case didFinishFetchingProducts(Result<[ProductTileItem], Error>)
    }
}

extension MerchantProductsView.Action: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (let .loadContent(lMerchantId, lMerchantName), let .loadContent(rMerchantId, rMerchantName)):
            return lMerchantId == rMerchantId && lMerchantName == rMerchantName
        case (let .didFinishLoadingContent(lResult), let .didFinishLoadingContent(rResult)):
            return compare(lResult, rResult)
        case (let .trackingAction(lTrackingAction), let .trackingAction(rTrackingAction)):
            return lTrackingAction == rTrackingAction
        case (let .outboundAction(lOutboundAction), let .outboundAction(rOutboundAction)):
            return lOutboundAction == rOutboundAction
        case (let .createFavorite(lProduct), let .createFavorite(rProduct)):
            return lProduct == rProduct
        case (let .removeFavorite(lProduct, lFavorite), let .removeFavorite(rProduct, rFavorite)):
            return lProduct == rProduct && lFavorite == rFavorite
        case (let .didFinishCreatingFavorite(lResult), let .didFinishCreatingFavorite(rResult)):
            return compare(lResult, rResult)
        case (let .didFinishRemovingFavorite(lResult), let .didFinishRemovingFavorite(rResult)):
            return compare(lResult, rResult)
        default:
            return false
        }
    }
}

extension MerchantProductsView.OutboundAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (let .didSelectProduct(lId), let .didSelectProduct(rId)):
            return lId == rId
        case (let .showLoginModal(lTitle, lDescription), let .showLoginModal(rTitle, rDescription)):
            return lTitle == rTitle && lDescription == rDescription
        case (let .didReportError(lError), let .didReportError(rError)):
            return compare(lError, rError)
        case (.didTapGoBack, .didTapGoBack):
            return true
        default:
            return false
        }
    }
}
