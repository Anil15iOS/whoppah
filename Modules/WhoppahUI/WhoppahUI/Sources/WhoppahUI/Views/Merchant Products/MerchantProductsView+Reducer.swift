//  
//  MerchantProductsView+Reducer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import ComposableArchitecture
import WhoppahModel

public extension MerchantProductsView {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
                
                ///
                /// 📄 Content
                ///
                
            case .loadContent(let merchantId, let merchantName):
                state.merchantId = merchantId
                state.merchantName = merchantName
                
                guard state.contentLoadingState == .uninitialized else {
                    state.contentLoadingState = .failed(error: WhoppahUI.StateError.invalidState)
                    return .none
                }
                
                state.contentLoadingState = .loading
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(MerchantProductsView.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                state.contentLoadingState = .finished
                if let merchantId = state.merchantId {
                    return Effect(value: .fetchProducts(merchantId: merchantId))
                } else {
                    return Effect(value: .outboundAction(.didReportError(error: WhoppahError.missingMerchantId)))
                }
            case .didFinishLoadingContent(.failure(let error)):
                state.contentLoadingState = .failed(error: error)
                return Effect(value: .outboundAction(.didReportError(error: error)))
            case .trackingAction(let action):
                _ = environment.trackingClient.track(action)
                return .none
            case .outboundAction(let action):
                _ = environment.outboundActionClient.perform(action)
                return .none

                ///
                /// 🪑 Products
                ///

            case .fetchProducts(let merchantId):
                state.fetchProductsState = .loading
                let filter = ProductFilter(key: .merchant,
                                           value: merchantId.uuidString)
                return environment
                    .productsClient
                    .fetchProducts([filter],
                                   Pagination(page: 1, limit: 1000),
                                   .default,
                                   .desc)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingProducts)
            case .didFinishFetchingProducts(.success(let products)):
                state.products = products
                state.fetchProductsState = .finished
                return .none
            case .didFinishFetchingProducts(.failure(let error)):
                state.fetchProductsState = .failed(error: error)
                return Effect(value: .outboundAction(.didReportError(error: error)))
                
                ///
                /// ❤️ Favorites
                ///
                
            case .createFavorite(let productId):
                return environment
                    .favoritesClient
                    .createFavorite(.init(contentType: .product, objectId: productId))
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishCreatingFavorite)
            case .didFinishCreatingFavorite(.success(let favoritedProduct)):
                state.products.replaceFavorite(product: favoritedProduct) { item in
                    var itemClone = item.clone
                    itemClone.favorite = favoritedProduct.favorite
                    return itemClone
                }
                return .none
            case .didFinishCreatingFavorite(.failure(let error)):
                switch error {
                case WhoppahError.userNotSignedIn:
                    return Effect(value: .outboundAction(.showLoginModal(title: state.model.userNotSignedInTitle,
                                                                         description: state.model.userNotSignedInDescription)))
                default:
                    return Effect(value: .outboundAction(.didReportError(error: error)))
                }
            case .removeFavorite(let productId, let favorite):
                return environment
                    .favoritesClient
                    .removeFavorite(productId, favorite)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishRemovingFavorite)
            case .didFinishRemovingFavorite(.success(let favoritedProduct)):
                state.products.replaceFavorite(product: favoritedProduct) { item in
                    var itemClone = item.clone
                    itemClone.favorite = nil
                    return itemClone
                }
                return .none
            case .didFinishRemovingFavorite(.failure(let error)):
                return .none
            }
        }
    }
}
