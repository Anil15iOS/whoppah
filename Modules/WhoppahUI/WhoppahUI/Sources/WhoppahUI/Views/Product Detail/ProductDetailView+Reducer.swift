//
//  ProductDetailView+Reducer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import ComposableArchitecture
import WhoppahModel

public extension ProductDetailView {
    struct Reducer {
        public init() {}

        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {

                ///
                /// 📄 Content
                ///

            case .loadContent:
                guard state.loadingState == .uninitialized else {
                    state.loadingState = .loadingStaticContent(.failed(error: WhoppahUI.StateError.invalidState))
                    return .none
                }
                state.loadingState = .loadingStaticContent(.loading)
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(ProductDetailView.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                state.loadingState = .loadingStaticContent(.finished)
                
                if let productId = state.productId {
                    return Effect(value: .fetchProduct(id: productId))
                } else if let productSlug = state.productSlug {
                    return Effect(value: .fetchProductBySlug(slug: productSlug))
                } else {
                    return Effect(value: .outboundAction(.didReportError(error: WhoppahError.couldNotFetchProductMissingIdentifierOrSlug)))
                }
            case .didFinishLoadingContent(.failure(let error)):
                state.loadingState = .loadingStaticContent(.failed(error: error))
                return Effect(value: .outboundAction(.didReportError(error: error)))
            case .trackingAction(let action):
                _ = environment.trackingClient.track(action)
                return .none
            case .outboundAction(let action):
                _ = environment.outboundActionClient.perform(action)
                return .none

                ///
                /// 🪑 Product
                ///

            case .fetchProduct(let id):
                state.loadingState = .loadingProduct(.loading)
                return environment.productDetailsClient.fetchProduct(id)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(ProductDetailView.Action.didFinishFetchingProduct)
            case .fetchProductBySlug(let slug):
                state.loadingState = .loadingProduct(.loading)
                return environment.productDetailsClient.fetchProductBySlug(slug)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(ProductDetailView.Action.didFinishFetchingProduct)
            case .didFinishFetchingProduct(.success(let product)):
                state.productId = product.id
                state.merchantId = product.merchant.id
                state.model.update(from: product)
                state.loadingState = .loadingProduct(.finished)
                return Effect(value: .fetchRelatedItems(product: product.id.uuidString))
            case .didFinishFetchingProduct(.failure(let error)):
                state.loadingState = .loadingProduct(.failed(error: error))
                return Effect(value: .outboundAction(.didReportError(error: error)))

                ///
                /// 👨‍👩‍👧‍👦 Related items
                ///

            case .fetchRelatedItems(let product):
                state.loadingState = .loadingRelatedProducts(.loading)
                return environment.productDetailsClient.fetchRelatedItems(product)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(ProductDetailView.Action.didFinishFetchingRelatedItems)
            case .didFinishFetchingRelatedItems(.success(let products)):
                state.model.updateRelatedProducts(products)
                state.loadingState = .loadingRelatedProducts(.finished)
                state.loadingState = .finished
                return Effect(value: .fetchReviews(merchantId: state.merchantId))
            case .didFinishFetchingRelatedItems(.failure(let error)):
                state.loadingState = .loadingRelatedProducts(.failed(error: error))
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
                if favoritedProduct.productId == state.productId {
                    state.model.product?.favorite = favoritedProduct.favorite
                } else {
                    state.model.relatedProducts.newProductItems.replaceFavorite(product: favoritedProduct) { item in
                        var itemClone = item.clone
                        itemClone.favorite = favoritedProduct.favorite
                        return itemClone
                    }
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
                if favoritedProduct.productId == state.productId {
                    state.model.product?.favorite = nil
                } else {
                    state.model.relatedProducts.newProductItems.replaceFavorite(product: favoritedProduct) { item in
                        var itemClone = item.clone
                        itemClone.favorite = nil
                        return itemClone
                    }
                }
                return .none
            case .didFinishRemovingFavorite(.failure(let error)):
                return .none

                ///
                /// 💬 Chat
                ///

            case .sendProductMessage(let product, let body):
                return environment
                    .productDetailsClient
                    .sendProductMessage(product.id, body)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishSendingProductMessage)
            case .didFinishSendingProductMessage(.success(let uuid)):
                if let chatId = uuid {
                    let openChatEffect: Effect<ProductDetailView.Action, Never> = .init(value: .outboundAction(.openChat(id: chatId)))
                    if let product = state.model.product,
                        let user = product.merchant.members.first {
                        let trackingEffect: Effect<ProductDetailView.Action, Never> = .init(value: .trackingAction(
                            .trackSendMessage(receiverId: user.id,
                                              productId: product.id,
                                              conversationId: chatId)))
                        return .merge(openChatEffect, trackingEffect)
                    }
                    return openChatEffect
                }
                return .none
            case .didFinishSendingProductMessage(.failure(let error)):
                return Effect(value: .outboundAction(.didReportError(error: error)))

                ///
                /// 💰 Buy now
                ///

            case .buyNow(let product, let amount):
                state.buyNowState = .loading
                return environment
                    .productDetailsClient
                    .createBid(product, amount, false)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishBuyNow)
            case .didFinishBuyNow(.success(let bid)):
                state.buyNowState = .finished
                if let product = state.model.product, let productId = state.productId {
                    return .merge(
                        Effect(value: .outboundAction(.openCheckout(productId: productId, bidId: bid.id))),
                        Effect(value: .trackingAction(.trackBid(product: product, bid: bid)))
                    )
                } else if let productId = state.productId {
                    return Effect(value: .outboundAction(.openCheckout(productId: productId, bidId: bid.id)))
                } else {
                    return .none
                }
            case .didFinishBuyNow(.failure(let error)):
                state.buyNowState = .failed(error: error)
                state.placeBidState = .failed(error: error)
                switch error {
                case WhoppahError.userNotSignedIn:
                    return Effect(value: .outboundAction(.showLoginModal(title: state.model.userNotSignedInTitle,
                                                                         description: state.model.userNotSignedInDescription)))
                default:
                    return Effect(value: .outboundAction(.didReportError(error: error)))
                }

                ///
                /// 🔨 Place bid
                ///

            case .placeBid(let product, let amount):
                state.placeBidState = .loading
                return environment
                    .productDetailsClient
                    .createBid(product, amount, true)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishPlaceBid)
            case .didFinishPlaceBid(.success(let bid)):
                guard let threadId = bid.thread else {
                    return Effect(value: .outboundAction(.didReportError(error: WhoppahError.missingChatThreadId)))
                }
                state.placeBidState = .finished

                if let product = state.model.product {
                    return .merge(
                        Effect(value: .outboundAction(.openChat(id: threadId))),
                        Effect(value: .trackingAction(.trackBid(product: product, bid: bid)))
                    )
                } else {
                    return Effect(value: .outboundAction(.openChat(id: threadId)))
                }
            case .didFinishPlaceBid(.failure(let error)):
                state.placeBidState = .failed(error: error)
                switch error {
                case WhoppahError.userNotSignedIn:
                    return Effect(value: .outboundAction(.showLoginModal(title: state.model.userNotSignedInTitle,
                                                                         description: state.model.userNotSignedInDescription)))
                default:
                    return Effect(value: .outboundAction(.didReportError(error: error)))
                }

                ///
                /// 🌏 Translation
                ///

            case .translate(let text, let language):
                state.translationState = .loading
                return environment
                    .productDetailsClient
                    .translate(text, language)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishTranslating)
            case .didFinishTranslating(.success(let translatedText)):
                state.translationState = .finished
                state.translatedProductDescription = translatedText
                return .none
            case .didFinishTranslating(.failure(let error)):
                state.translationState = .failed(error: error)
                state.translatedProductDescription = state.model.product?.description
                return Effect(value: .outboundAction(.didReportError(error: error)))

                ///
                /// 📔 Reviews
                ///

            case .fetchReviews(let merchantId):
                state.reviewsState = .loading
                return environment
                    .productDetailsClient
                    .fetchReviews(merchantId)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingReviews)
            case .didFinishFetchingReviews(.success(let reviews)):
                state.reviewsState = .finished
                state.reviews = reviews
                return .none
            case .didFinishFetchingReviews(.failure(let error)):
                state.reviewsState = .failed(error: error)
                return Effect(value: .outboundAction(.didReportError(error: error)))

                ///
                /// ⚠️ Abuse
                ///

            case .reportAbuse(let product, let type, let reason, let description):
                let id = type == .product ? product.id : product.merchant.id
                let input = AbuseReportInput(id: id,
                                             type: type,
                                             reason: reason,
                                             description: description)

                state.reportAbuseState = .loading

                return environment
                    .productDetailsClient
                    .reportAbuse(input)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishReportingAbuse)
            case .didFinishReportingAbuse(.success(let result)):
                guard result else {
                    state.reportAbuseState = .failed(error: WhoppahError.couldNotCreateAbuseReport)
                    return Effect(value: .outboundAction(.didReportError(error: WhoppahError.couldNotCreateAbuseReport)))
                }
                state.reportAbuseState = .finished
                return .none
            case .didFinishReportingAbuse(.failure(let error)):
                state.reportAbuseState = .failed(error: error)
                switch error {
                case WhoppahError.userNotSignedIn:
                    return Effect(value: .outboundAction(.showLoginModal(title: state.model.userNotSignedInTitle,
                                                                         description: state.model.userNotSignedInDescription)))
                default:
                    return Effect(value: .outboundAction(.didReportError(error: error)))
                }
            }
        }
    }
}
