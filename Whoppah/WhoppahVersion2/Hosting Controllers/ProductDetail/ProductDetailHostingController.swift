//
//  ProductDetailHostingController.swift
//  Whoppah
//
//  Created by Marko Stojkovic on 6.4.22..
//  Copyright © 2022 Whoppah. All rights reserved.
//

import UIKit
import SwiftUI
import WhoppahUI
import ComposableArchitecture
import Resolver
import WhoppahRepository
import WhoppahModel
import WhoppahCoreNext
import Combine
import IQKeyboardManagerSwift

class ProductDetailHostingController: WhoppahUIHostingController<ProductDetailView,
                                      ProductDetailView.Model,
                                      ProductDetailView.ViewState,
                                      ProductDetailView.Action,
                                      ProductDetailView.OutboundAction,
                                      ProductDetailView.TrackingAction>
{
    @LazyInjected private var eventTracking: EventTrackingService
    @LazyInjected private var productDetailsRepository: ProductDetailsRepository
    @LazyInjected private var userProvider: UserProviding
    @LazyInjected private var productRepository: ProductRepository
    @LazyInjected private var chatRepository: ChatRepository
    @LazyInjected private var shippingMethodsRepository: ShippingMethodsRepository
    @LazyInjected private var auctionRepository: AuctionRepository
    @LazyInjected private var languageTranslationRepository: LanguageTranslationRepository
    @LazyInjected private var reviewsRepository: ReviewsRepository
    @LazyInjected private var abuseRepository: AbuseRepository
    @LazyInjected private var crashReporter: CrashReporter

    private var productDetailsClient: WhoppahUI.ProductDetailsClient!
    private var favoritesClient: WhoppahUI.FavoritesClient!
    private let productId: UUID?
    private let productSlug: String?
    private var currentUserCancellable: AnyCancellable? = nil

    init(productId: UUID?, productSlug: String?) {
        self.productId = productId
        self.productSlug = productSlug
        super.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> ProductDetailView {

        let initialViewState = ProductDetailView.ViewState.init(loadingState: .uninitialized,
                                                                model: .initial,
                                                                productId: self.productId,
                                                                productSlug: self.productSlug,
                                                                user: { self.userProvider.currentUser } )
        
        productDetailsClient = .init(fetchProduct: { [weak self] productId in
            guard let self = self else {
                return Fail(outputType: Product.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productDetailsRepository
                .fetchProduct(id: productId)
                .eraseToEffect()
        }, fetchProductBySlug: { [weak self] productSlug in
            guard let self = self else {
                return Fail(outputType: Product.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productDetailsRepository
                .fetchProduct(slug: productSlug)
                .eraseToEffect()
        }, fetchRelatedItems: { [weak self] product in
            guard let self = self else {
                return Fail(outputType: [ProductTileItem].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productDetailsRepository
                .fetchRelatedItems(product: product)    
                .eraseToEffect()
        }, fetchReviews: { [weak self] merchantId in
            guard let self = self else {
                return Fail(outputType: [ProductReview].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .reviewsRepository
                .fetchReviews(merchantId: merchantId)
                .eraseToAnyPublisher()
                .eraseToEffect()
        }, sendProductMessage: { [weak self] id, message in
            guard let self = self else {
                return Fail(outputType: UUID?.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .chatRepository
                .sendProductMessage(id: id, body: message)
                .eraseToAnyPublisher()
                .eraseToEffect()
        }, createBid: { [weak self] product, amount, createThread in
            guard let self = self else {
                return Fail(outputType: Bid.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .auctionRepository
                .createBid(product: product, amount: amount, createThread: createThread)
                .eraseToAnyPublisher()
                .eraseToEffect()
        }, translate: { [weak self] text, language in
            guard let self = self else {
                return Fail(outputType: String.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .languageTranslationRepository
                .translate(strings: [text], language: language)
                .tryMap({ result in
                    guard let first = result?.translatedTexts.first else {
                        throw WhoppahError.noTranslationAvailable
                    }
                    return first
                })
                .eraseToAnyPublisher()
                .eraseToEffect()
        }, reportAbuse: { [weak self] input in
            guard let self = self else {
                return Fail(outputType: Bool.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .abuseRepository
                .reportAbuse(input)
                .eraseToAnyPublisher()
                .eraseToEffect()
        })

        favoritesClient = .init(createFavorite: { [weak self] favoriteInput in
            guard let self = self else {
                return Fail(outputType: FavoritedProduct.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productRepository
                .createFavorite(favoriteInput)
                .eraseToEffect()
        }, removeFavorite: { [weak self] (productId, favorite) in
            guard let self = self else {
                return Fail(outputType: FavoritedProduct.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productRepository
                .removeFavorite(id: productId, favorite: favorite)
                .eraseToEffect()
        }, currentUserFavorites: {
            return .none
        })

        let reducer = ProductDetailView.Reducer().reducer

        let environment = ProductDetailView.Environment(localizationClient: localizationClient,
                                                        trackingClient: trackingClient,
                                                        outboundActionClient: outboundActionClient,
                                                        productDetailsClient: productDetailsClient,
                                                        favoritesClient: favoritesClient,
                                                        mainQueue: .main)

        let store: Store<ProductDetailView.ViewState, ProductDetailView.Action> =
            .init(initialState: initialViewState,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store)
    }

    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: ProductDetailView.OutboundAction) -> Effect<ProductDetailView.Action, Never> {
        switch outboundAction {
        case .didTapBoostAd:
            break // Not in this release
        case .didTapGoBack:
            self.navigationController?.popViewController(animated: true, completion: nil)
        case .didTapShareProduct(let product):
            guard let navigationController = navigationController,
                  let url = URL(string: product.shareLink) else { return .none }

            let activityItems: [Any] = [product.title, url]

            let viewController = UIActivityViewController.createShareVC(
                activityItems: activityItems,
                sourceView: navigationController.view) { [weak self] activity in
                    guard let self = self else { return }
                    self.eventTracking.ad.trackShareCompleted(product: product,
                                                              shareNetwork: activity.rawValue)
                }
            DispatchQueue.main.async {
                navigationController.present(viewController, animated: true, completion: nil)
            }
        case .didTapCallNumber(phoneNumber: let phoneNumber):
            self.callPhone(number: phoneNumber)
        case .didTapContactSupport(email: let email,
                                   subject: let subject,
                                   body: let body):
            self.openMail(email: email,
                          subject: subject,
                          body: body)
        case .openChat(let id):
            guard let navigationController = navigationController else { return .none }
            let coordinator = ThreadCoordinator(navigationController: navigationController)
            coordinator.start(threadID: id)
        case .openCheckout(let productId, let bidId):
            guard let navigationController = navigationController else { return .none }
            let coordinator = AdDetailsCoordinator(navigationController: navigationController)
            coordinator.showCheckout(id: productId, bidId: bidId, orderId: nil, backPressed: nil)
            eventTracking.trackBeginCheckout(source: .pdp)
        case .showLoginModal(title: let title, description: let description):
            guard let navigationController = navigationController else { return .none }
            let coordinator = TabsCoordinator(navigationController: navigationController)
            coordinator.openContextualSignup(title: title,
                                             description: description)
        case .didReportError(error: let error):
            crashReporter.log(error: error)
            return .none
        case .didSelectProduct(let productId):
            guard let navigationController = navigationController else { return .none }
            let coordinator = AdDetailsCoordinator(navigationController: navigationController)
            coordinator.start(adID: productId)
            return .none.eraseToEffect()
        case .didTapShowMerchantProducts(let merchantId, let merchantName):
            guard let navigationController = navigationController else { return .none }
            let merchantProductsController = MerchantProductsViewHostingController(merchantId: merchantId,
                                                                                   merchantName: merchantName)
            navigationController.pushViewController(merchantProductsController,
                                                    animated: true)
        }
        return .none.eraseToEffect()
    }

    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: ProductDetailView.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .trackFavouriteStatusChanged(let product, let favorited):
            eventTracking.trackFavouriteStatusChanged(product: product,
                                                      status: favorited)
        case .trackSendMessage(let receiverId,
                               let productId,
                               let conversationId):
            eventTracking.trackSendMessage(receiverID: receiverId,
                                           adID: productId,
                                           conversationID: conversationId,
                                           counterBid: nil,
                                           textMessage: true,
                                           isPDPQuestion: true)
        case .trackBid(let product, let bid):
            eventTracking.trackBid(product: product,
                                   bid: bid.amount,
                                   source: .pdp)
            eventTracking.trackAddedToCart(product: product)
        case .trackSafeShoppingBannerClicked:
            eventTracking.ad.trackSafeShoppingBannerClicked()
        case .trackShareCompleted(let product, let shareNetwork):
            eventTracking.ad.trackShareCompleted(product: product,
                                                 shareNetwork: shareNetwork)
        case .trackShareClicked(let product):
            eventTracking.ad.trackShareClicked(product: product)
        case .trackAdDetailsBuyNow(let product, let categoryText):
            eventTracking.trackAdDetailsBuyNow(product: product,
                                               categoryText: categoryText,
                                               source: .pdp)
            eventTracking.trackAddedToCart(product: product)
        case .trackAdDetailsBid(let product, let categoryText, let maxBid):
            eventTracking.trackAdDetailsBid(product: product,
                                            categoryText: categoryText,
                                            maxBid: maxBid,
                                            source: .pdp)
        case .trackAdViewed(let product):
            eventTracking.trackAdViewed(product: product)
        case .trackPhotoViewed(let product, let photoId):
            eventTracking.trackPhotoViewed(product: product,
                                           photoID: photoId,
                                           isFullScreen: false)
        case .trackVideoViewed(let product):
            eventTracking.trackVideoViewed(product: product,
                                           isFullScreen: false,
                                           page: .adDetails)
        case .trackLaunchedARView(let product):
            eventTracking.trackLaunchedARView(product: product)
        case .trackDismissedARView(let product, let timeSpentSecs):
            eventTracking.trackDismissedARView(product: product,
                                               timeSpentSecs: timeSpentSecs)
        }

        return .none
    }

    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<ProductDetailView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(ProductDetailView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func callPhone(number: String){
        let phone = "tel://"
        let phoneNumberformatted = phone + number
        guard let url = URL(string: phoneNumberformatted) else { return }
        UIApplication.shared.open(url)
    }

    private func openMail(email: String,
                          subject: String,
                          body: String){
        if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
