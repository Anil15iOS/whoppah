//
//  MerchantProductsViewHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 05/05/2022.
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

class MerchantProductsViewHostingController: WhoppahUIHostingController<MerchantProductsView,
                                             MerchantProductsView.Model,
                                             MerchantProductsView.ViewState,
                                             MerchantProductsView.Action,
                                             MerchantProductsView.OutboundAction,
                                             MerchantProductsView.TrackingAction>
{
    @LazyInjected private var crashReporter: CrashReporter
    @LazyInjected private var productsRepository: ProductsRepository
    @LazyInjected private var productRepository: ProductRepository
    
    private var productsClient: WhoppahUI.ProductsClient!
    private var favoritesClient: WhoppahUI.FavoritesClient!
    private let merchantId: UUID
    private let merchantName: String
    
    init(merchantId: UUID,
         merchantName: String) {
        self.merchantId = merchantId
        self.merchantName = merchantName
        super.init()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> MerchantProductsView {
        productsClient = .init(fetchProducts: { [weak self] productFilter, pagination, sort, ordering in
            guard let self = self else {
                return Fail(outputType: [ProductTileItem].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .productsRepository
                .fetchProducts(filters: productFilter,
                               pagination: pagination,
                               sort: sort,
                               ordering: ordering)
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
        
        let reducer = MerchantProductsView.Reducer().reducer
        
        let environment = MerchantProductsView.Environment(localizationClient: localizationClient,
                                                           trackingClient: trackingClient,
                                                           outboundActionClient: outboundActionClient,
                                                           favoritesClient: favoritesClient,
                                                           productsClient: productsClient,
                                                           mainQueue: .main)

        let store: Store<MerchantProductsView.ViewState, MerchantProductsView.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store,
                     merchantId: merchantId,
                     merchantName: merchantName)
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: MerchantProductsView.TrackingAction) -> Effect<Void, Never> {
        return .none
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: MerchantProductsView.OutboundAction) -> Effect<MerchantProductsView.Action, Never> {
        switch outboundAction {
        case .didTapGoBack:
            self.navigationController?.popViewController(animated: true, completion: nil)
        case .didReportError(let error):
            crashReporter.log(error: error)
        case .showLoginModal(let title, let description):
            guard let navigationController = navigationController else { return .none }
            let coordinator = TabsCoordinator(navigationController: navigationController)
            coordinator.openContextualSignup(title: title,
                                             description: description)
        case .didSelectProduct(let productId):
            guard let navigationController = navigationController else { return .none }
            let coordinator = AdDetailsCoordinator(navigationController: navigationController)
            coordinator.start(adID: productId)
        }
        
        return .none
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<MerchantProductsView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(MerchantProductsView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }

}
