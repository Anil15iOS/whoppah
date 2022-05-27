//
//  ProductDetailViewTests.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 19/04/2022.
//

import Foundation
import XCTest
@testable import WhoppahUI
import WhoppahModel
import ComposableArchitecture
import Combine

final class ProductDetailViewTests: WhoppahUITestsBase {
    lazy var mockModel: ProductDetailView.Model = {
        ProductDetailView.Model.mock
    }()
    
    lazy var mockProduct: WhoppahModel.Product = {
        WhoppahModel.Product.randomWithId(productId: UUID())
    }()
    
    lazy var localizationSuccessClient: WhoppahUI.LocalizationClient<ProductDetailView.Model> = {
        .init {
            return Effect(value: self.mockModel)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    }()
    
    lazy var localizationFailureClient: WhoppahUI.LocalizationClient<ProductDetailView.Model> = {
        .init {
            return Fail(outputType: ProductDetailView.Model.self,
                        failure: WhoppahUI.LocalizationClientError.couldNotLoad)
                .eraseToEffect()
        }
    }()

    lazy var trackingClient: WhoppahUI.TrackingClient<ProductDetailView.TrackingAction> = {
        .init { trackingAction in
            return .none
        }
    }()
    
    lazy var outboundActionClient: WhoppahUI.OutboundActionClient<ProductDetailView.OutboundAction, Effect<ProductDetailView.Action, Never>> = {
        .init { [weak self] outboundAction in
            return .none.eraseToEffect()
        }
    }()
    
    lazy var favoritesClient: WhoppahUI.FavoritesClient = {
        .init { _ in
            return .none
        } removeFavorite: { _, _ in
            return .none
        } currentUserFavorites: {
            return .none
        }
    }()
    
    lazy var productDetailsClient: WhoppahUI.ProductDetailsClient = {
        .init(fetchProduct: { productId in
            return Effect(value: self.mockProduct)
                .eraseToEffect()
        }, fetchProductBySlug: { productSlug in
            return Effect(value: self.mockProduct)
                .eraseToEffect()
        }, fetchRelatedItems: { _ in
            return .none
        }, fetchReviews: { merchantId in
            return .none
        }, sendProductMessage: { id, message in
            return .none
        }, createBid: { product, amount, createThread in
            return .none
        }, translate: { text, language in
            return .none
        }, reportAbuse: { input in
            return .none
        })
    }()
    
    lazy var productDetailsFailureClient: WhoppahUI.ProductDetailsClient = {
        .init(fetchProduct: { productId in
            return Fail(outputType: WhoppahModel.Product.self,
                        failure: MockError.mockError)
                .eraseToEffect()
        }, fetchProductBySlug: { productSlug in
            return Fail(outputType: WhoppahModel.Product.self,
                        failure: MockError.mockError)
                .eraseToEffect()
        }, fetchRelatedItems: { _ in
            return .none
        }, fetchReviews: { merchantId in
            return .none
        }, sendProductMessage: { id, message in
            return .none
        }, createBid: { product, amount, createThread in
            return .none
        }, translate: { text, language in
            return .none
        }, reportAbuse: { input in
            return .none
        })
    }()
    
    func testLocalizationAndProductByIdClientSuccess() {
        let environment = ProductDetailView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            productDetailsClient: productDetailsClient,
            favoritesClient: favoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())
        
        var viewState = ProductDetailView.ViewState.initial
        viewState.productId = mockProduct.id
        
        let testStore = TestStore(initialState:
                                    viewState,
                                  reducer: ProductDetailView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loadingStaticContent(.loading)
        }
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(mockModel))) {
            $0.model = self.mockModel
            $0.loadingState = .loadingStaticContent(.finished)
        }
        advance()
        testStore.receive(.fetchProduct(id: mockProduct.id)) {
            $0.loadingState = .loadingProduct(.loading)
        }
        advance()
        testStore.receive(.didFinishFetchingProduct(.success(mockProduct))) {
            $0.productId = self.mockProduct.id
            $0.model.product = self.mockProduct
            $0.merchantId = self.mockProduct.merchant.id
            $0.loadingState = .loadingProduct(.finished)
        }
        advance()
        testStore.receive(.fetchRelatedItems(product: mockProduct.id.uuidString)) {
            $0.loadingState = .loadingRelatedProducts(.loading)
        }
    }
    
    func testLocalizationAndProductBySlugClientSuccess() {
        let environment = ProductDetailView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            productDetailsClient: productDetailsClient,
            favoritesClient: favoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())
        
        var viewState = ProductDetailView.ViewState.initial
        viewState.productSlug = mockProduct.slug
        
        let testStore = TestStore(initialState:
                                    viewState,
                                  reducer: ProductDetailView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loadingStaticContent(.loading)
        }
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(mockModel))) {
            $0.model = self.mockModel
            $0.loadingState = .loadingStaticContent(.finished)
        }
        advance()
        testStore.receive(.fetchProductBySlug(slug: mockProduct.slug)) {
            $0.loadingState = .loadingProduct(.loading)
        }
        advance()
        testStore.receive(.didFinishFetchingProduct(.success(mockProduct))) {
            $0.productId = self.mockProduct.id
            $0.model.product = self.mockProduct
            $0.merchantId = self.mockProduct.merchant.id
            $0.loadingState = .loadingProduct(.finished)
        }
        advance()
        testStore.receive(.fetchRelatedItems(product: mockProduct.id.uuidString)) {
            $0.loadingState = .loadingRelatedProducts(.loading)
        }
    }
    
    func testProductClientFailureWhenNoIdentifiersGiven() {
        let environment = ProductDetailView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            productDetailsClient: productDetailsClient,
            favoritesClient: favoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())
        
        let viewState = ProductDetailView.ViewState.initial
        
        let testStore = TestStore(initialState:
                                    viewState,
                                  reducer: ProductDetailView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loadingStaticContent(.loading)
        }
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(mockModel))) {
            $0.model = self.mockModel
            $0.loadingState = .loadingStaticContent(.finished)
        }
        advance()
        let error = WhoppahError.couldNotFetchProductMissingIdentifierOrSlug
        testStore.receive(.outboundAction(.didReportError(error: error)))
    }
    
    func testLocalizationClientFailure() {
        let environment = ProductDetailView.Environment(
            localizationClient: localizationFailureClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            productDetailsClient: productDetailsClient,
            favoritesClient: favoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())

        let error = WhoppahUI.LocalizationClientError.couldNotLoad
        var viewState = ProductDetailView.ViewState.initial
        viewState.productId = mockProduct.id
        
        let testStore = TestStore(initialState:
                                    viewState,
                                  reducer: ProductDetailView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.model.product = nil
            $0.loadingState = .loadingStaticContent(.loading)
        }
        advance()
        testStore.receive(.didFinishLoadingContent(.failure(error))) {
            $0.loadingState = .loadingStaticContent(.failed(error: error))
        }
        advance()
        testStore.receive(.outboundAction(.didReportError(error: error))) { _ in
            
        }
    }
    
    func testProductClientFailure() {
        let environment = ProductDetailView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            productDetailsClient: productDetailsFailureClient,
            favoritesClient: favoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())
        
        var viewState = ProductDetailView.ViewState.initial
        viewState.productId = mockProduct.id
        
        let testStore = TestStore(initialState:
                                    viewState,
                                  reducer: ProductDetailView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loadingStaticContent(.loading)
        }
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(mockModel))) {
            $0.model = self.mockModel
            $0.loadingState = .loadingStaticContent(.finished)
        }
        advance()
        testStore.receive(.fetchProduct(id: mockProduct.id)) {
            $0.loadingState = .loadingProduct(.loading)
        }
        advance()
        let error = MockError.mockError
        testStore.receive(.didFinishFetchingProduct(.failure(error))) {
            $0.loadingState = .loadingProduct(.failed(error: error))
        }
        advance()
        testStore.receive(.outboundAction(.didReportError(error: error))) { _ in
            
        }
    }
}
