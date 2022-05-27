//  
//  ProductDetailView+ViewState.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import WhoppahModel

public extension ProductDetailView {
    struct ViewState: Equatable {
        public enum LoadingState {
            case uninitialized
            case loading
            case failed(error: Error)
            case finished
        }

        public enum ContentLoadingState {
            case uninitialized
            case loadingStaticContent(LoadingState)
            case loadingProduct(LoadingState)
            case loadingSimilarProducts(LoadingState)
            case loadingRelatedProducts(LoadingState)
            case finished
        }

        var loadingState: ContentLoadingState = .uninitialized
        var buyNowState: LoadingState = .uninitialized
        var placeBidState: LoadingState = .uninitialized
        var translationState: LoadingState = .uninitialized
        var reviewsState: LoadingState = .uninitialized
        var reportAbuseState: LoadingState = .uninitialized
        var model: Model
        var productId: UUID?
        var productSlug: String?
        var merchantId: UUID = UUID()
        var translatedProductDescription: String? = nil
        var reviews: [WhoppahModel.ProductReview] = []
        @IgnoreEquatable
        var user: () -> WhoppahModel.Member?

        public static let initial = Self(loadingState: .uninitialized,
                                         model: .initial,
                                         productId: nil,
                                         productSlug: nil,
                                         user: { nil })

        public init(loadingState: ContentLoadingState,
                    model: Model,
                    productId: UUID?,
                    productSlug: String?,
                    user: @escaping () -> WhoppahModel.Member?)
        {
            self.loadingState = loadingState
            self.model = model
            self.productId = productId
            self.productSlug = productSlug
            self.user = user
        }
    }
}

extension ProductDetailView.ViewState.LoadingState: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.uninitialized, .uninitialized): return true
        case (.loading, .loading): return true
        case (let .failed(lError), let .failed(rError)): return compare(lError, rError)
        case (.finished, .finished): return true
        default: return false
        }
    }
}

extension ProductDetailView.ViewState.ContentLoadingState: Equatable {
    var failedWithError: Error? {
        switch self {
        case let .loadingStaticContent(.failed(error)): return error
        case let .loadingProduct(.failed(error)): return error
        case let .loadingSimilarProducts(.failed(error)): return error
        case let .loadingRelatedProducts(.failed(error)): return error
        default: return nil
        }
    }

    var isLoading: Bool {
        switch self {
        case .loadingStaticContent(.loading): return true
        case .loadingProduct(.loading): return true
        case .loadingSimilarProducts(.loading): return true
        case .loadingRelatedProducts(.loading): return true
        default: return false
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.uninitialized, .uninitialized):
            return true
        case (let .loadingStaticContent(lState), let .loadingStaticContent(rState)):
            return lState == rState
        case (let .loadingProduct(lState), let .loadingProduct(rState)):
            return lState == rState
        case (let .loadingSimilarProducts(lState), let .loadingSimilarProducts(rState)):
            return lState == rState
        case (let .loadingRelatedProducts(lState), let .loadingRelatedProducts(rState)):
            return lState == rState
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}
