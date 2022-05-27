//
//  SearchViewHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 09/03/2022.
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

class SearchViewHostingController: WhoppahUIHostingController<SearchView,
                                   SearchView.Model,
                                   SearchView.ViewState,
                                   SearchView.Action,
                                   SearchView.OutboundAction,
                                   SearchView.TrackingAction>
{
    @LazyInjected private var searchRepository: SearchRepository
    @LazyInjected private var attributesRepository: AttributeRepository
    @LazyInjected private var categoriesRepository: CategoryRepository
    @LazyInjected private var productRepository: ProductRepository
    @LazyInjected private var eventTracking: EventTrackingService
    @LazyInjected private var userRepository: UserRepository
    @LazyInjected private var crashReporter: CrashReporter
    
    private var searchClient: WhoppahUI.SearchClient!
    private var attributesClient: WhoppahUI.AttributesClient!
    private var categoriesClient: WhoppahUI.CategoriesClient!
    private var favoritesClient: WhoppahUI.FavoritesClient!
    private let searchInput: SearchProductsInput!
    
    private weak var parentNavigationController: UINavigationController?
    
    init(searchInput: SearchProductsInput, parentNavigationController: UINavigationController) {
        self.searchInput = searchInput
        self.parentNavigationController = parentNavigationController
        super.init()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> SearchView {
        searchClient = .init(search: { [weak self] searchProductsInput in
            guard let self = self else {
                return Fail(outputType: ProductSearchResultsSet.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .searchRepository
                .search(input: searchProductsInput)
                .eraseToEffect()
        }, saveSearch: { [weak self] searchProductsInput in
            guard let self = self else {
                return Fail(outputType: Bool.self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .searchRepository
                .saveSearch(input: searchProductsInput)
                .eraseToEffect()
        })
        
        attributesClient = .init(fetchAttributes: { [weak self] attributeType in
            guard let self = self else { return .none.eraseToEffect() }
            return self
                .attributesRepository
                .fetchSearchAttributes(attributeType)
                .eraseToEffect()
        })
        
        categoriesClient = .init(fetchCategoriesByLevel: { [weak self] level in
            guard let self = self else {
                return Fail(outputType: [WhoppahModel.Category].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .categoriesRepository
                .loadCategories(atLevel: level)
                .eraseToEffect()
        }, fetchSubCategoriesBySlug: { [weak self] slug in
            guard let self = self else {
                return Fail(outputType: [WhoppahModel.Category].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .categoriesRepository
                .subcategories(categorySlug: slug,
                               style: nil,
                               brand: nil)
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
        }, currentUserFavorites: { [weak self] in
            guard let self = self else {
                return Fail(outputType: [UUID: Favorite].self, failure: WhoppahError.deallocatedSelf)
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            }
            return self
                .userRepository
                .userFavorites(pagination: .init(page: 1, limit: 1000))
                .eraseToEffect()
        })

        let environment = SearchView.Environment(
            localizationClient: localizationClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            searchClient: searchClient,
            attributesClient: attributesClient,
            categoriesClient: categoriesClient,
            favoritesClient: favoritesClient,
            mainQueue: .main)

        let reducer = SearchView.Reducer().reducer

        let store: Store<SearchView.ViewState, SearchView.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store, searchInput: searchInput)
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: SearchView.OutboundAction) -> Effect<SearchView.Action, Never> {
        switch outboundAction {
        case .didSelectProduct(let productId):
            guard let navigationController = navigationController else { return .none }
            let coordinator = AdDetailsCoordinator(navigationController: navigationController)
            coordinator.start(adID: productId)
            return .none.eraseToEffect()
        case .didTapCloseButton:
            DispatchQueue.main.async { [weak self] in
                self?.parentNavigationController?.popViewController(animated: true)
            }
            return .none
        case .didReportError(let error):
            crashReporter.log(error: error)
            return .none
        case .showLoginModal(let title, let description):
            guard let navigationController = navigationController else { return .none }
            let coordinator = TabsCoordinator(navigationController: navigationController)
            coordinator.openContextualSignup(title: title,
                                             description: description)
            return .none
        }
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: SearchView.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .didPerformSearch(let query):
            eventTracking.home.trackSearchPerformed(text: query)
        case .didTapSort(let type, let order):
            eventTracking.searchResults.trackSortClicked(type: type, order: order)
        case .didTapShowFilters:
            eventTracking.searchResults.trackFilterClicked()
        case .didScrollSearch(let page):
            eventTracking.searchResults.trackSearchScrolled(scrollDepth: page)
        case .didSelectProduct(let product):
            eventTracking.trackClickProduct(ad: product, page: .search)
        }
        return .none
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<SearchView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(SearchView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
