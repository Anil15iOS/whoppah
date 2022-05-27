//  
//  SearchView+Reducer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/03/2022.
//

import ComposableArchitecture
import WhoppahModel
import Combine

public extension SearchView {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
                
                ///
                /// 📖 Localized static content loading
                ///
                
            case .loadContent:
                guard state.loadingState == .uninitialized else {
                    state.loadingState = .loadingStaticContent(.failed(error: WhoppahUI.StateError.invalidState))
                    return .none
                }
                state.loadingState = .loadingStaticContent(.loading)
                return environment
                    .localizationClient
                    .fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(SearchView.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.loadingState = .loadingStaticContent(.finished)
                state.model = model
                return Effect(value: .fetchNextAttribute)
            case .didFinishLoadingContent(.failure(let error)):
                state.loadingState = .loadingStaticContent(.failed(error: error))
                return Effect(value: .outboundAction(.didReportError(error: error)))
                
                ///
                /// 👣 Tracking
                ///
            
            case .trackingAction(let action):
                _ = environment.trackingClient.track(action)
                return .none
                
                ///
                /// ⬅️ Outbound actions
                ///
                
            case .outboundAction(let action):
                _ = environment.outboundActionClient.perform(action)
                switch(action) {
                case .didSelectProduct(let id):
                    state.currentlySelectedProduct = id
                default:
                    return .none
                }
                return .none
                
                ///
                /// 🔍 Search
                ///
                
            case .searchAction(let searchInput, let clearCurrentResults):
                guard searchInput != state.currentSearchInput else { return .none }

                state.searchState = .loading
                state.currentSearchInput = searchInput
                
                if clearCurrentResults {
                    state.currentSearchResults.removeAll()
                }
                
                return environment
                    .searchClient
                    .search(searchInput)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(SearchView.Action.didReceiveSearchResults)
            case .didReceiveSearchResults(.success(let searchResultsSet)):
                state.latestSearchResultsSet = searchResultsSet
                state.latestSearchFacetsSet.update(from: searchResultsSet,
                                                   filterModel: state.model.filters)

                // [WTP-147] We need to ensure there are no duplicate items, otherwise
                // LazyVGrid will cause a crash on iOS 14.
                var items = searchResultsSet.items
                items.removeAll { searchItem in
                    state.currentSearchResults.contains(where: { currentItem in
                        searchItem == currentItem
                    })
                }
                state.currentSearchResults += items
                
                state.searchState = .finished
                state.saveSearchState = .uninitialized
                return .none
            case .didReceiveSearchResults(.failure(let error)):
                state.searchState = .failed(error: error)
                return Effect(value: .outboundAction(.didReportError(error: error)))
            case .didTapSaveSearch(let searchInput):
                state.saveSearchState = .saving
                return environment
                    .searchClient
                    .saveSearch(searchInput)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(SearchView.Action.didFinishSavingSearch)
            case .didFinishSavingSearch(.success(let success)):
                state.saveSearchState = .finished
                return .none
            case .didFinishSavingSearch(.failure(let error)):
                state.saveSearchState = .failed(error: error)
                return Effect(value: .outboundAction(.didReportError(error: error)))
                
                ///
                /// 👆 Button taps
                ///

            case .didTapShowFiltersButton:
                if let searchResults = state.latestSearchResultsSet {
                    state.previewSearchFacetsSet.update(from: searchResults,
                                                        filterModel: state.model.filters)
                }
                state.viewState = .showingFilters
                return .none
            case .didTapShowResultsButton:
                state.viewState = .showingSearchResults
                return .none
            case .didTapCloseFiltersButton:
                state.viewState = .showingSearchResults
                return .none
                
                ///
                /// 🎨 Attributes
                ///
                
            case .fetchNextAttribute:
                guard let attributeType = state.attributesToLoad.first
                else {
                    state.loadingState = .loadingAttributes(.finished)
                    return Effect(value: .fetchCategoryHierarchy)
                }
                
                state.attributesToLoad.removeFirst()
                state.loadingState = .loadingAttributes(.loading)
                
                return environment
                    .attributesClient
                    .fetchAttributes(attributeType)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingAttributes)
            case .didFinishFetchingAttributes(.success(let attributes)):
                guard let firstAttribute = attributes.first else {
                    return Effect(value: .fetchNextAttribute)
                }
                
                switch firstAttribute.self {
                case _ as WhoppahModel.Brand:
                    state.model.filters.brands = attributes.compactMap({ $0 as? WhoppahModel.Brand })
                case _ as WhoppahModel.Material:
                    state.model.filters.materials = attributes.compactMap({ $0 as? WhoppahModel.Material })
                case _ as WhoppahModel.Style:
                    state.model.filters.styles = attributes.compactMap({ $0 as? WhoppahModel.Style })
                case _ as WhoppahModel.Color:
                    state.model.filters.colors = attributes.compactMap({ $0 as? WhoppahModel.Color })
                default:
                    return Effect(value: .fetchNextAttribute)
                }
                
                return Effect(value: .fetchNextAttribute)
            case .didFinishFetchingAttributes(.failure(let error)):
                state.loadingState = .loadingAttributes(.failed(error: error))
                return Effect(value: .outboundAction(.didReportError(error: error)))
            
                ///
                /// 🗄 Categories
                ///
            
            case .fetchCategoryHierarchy:
                state.loadingState = .loadingCategories(.loading)
                return environment
                    .categoriesClient
                    .fetchCategoriesByLevel(0)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingCategoryHierarchy)
            case .didFinishFetchingCategoryHierarchy(.success(let categories)):
                state.model.filters.categories = categories
                state.loadingState = .loadingCategories(.finished)
                state.loadingState = .finished
                return .none
            case .didFinishFetchingCategoryHierarchy(.failure(let error)):
                state.loadingState = .loadingCategories(.failed(error: error))
                return Effect(value: .outboundAction(.didReportError(error: error)))
            case .fetchCategories(let slug):
                state.loadingSubcategoriesState = .loading
                return environment
                    .categoriesClient
                    .fetchSubCategoriesBySlug(slug)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingCategories)
            case .didFinishFetchingCategories(.success(let categories)):
                state.visibleSubCategories = categories
                state.loadingSubcategoriesState = .finished
                return .none
            case .didFinishFetchingCategories(.failure(let error)):
                state.visibleSubCategories = nil
                state.loadingSubcategoriesState = .failed(error: error)
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
                state.currentSearchResults.replaceFavorite(product: favoritedProduct) { item in
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
                state.currentSearchResults.replaceFavorite(product: favoritedProduct) { item in
                    var itemClone = item.clone
                    itemClone.favorite = nil
                    return itemClone
                }
                return .none
            case .didFinishRemovingFavorite(.failure(let error)):
                return .none
            case .fetchUserFavorites:
                state.currentlySelectedProduct = nil
                return environment
                    .favoritesClient
                    .currentUserFavorites()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(Action.didFinishFetchingUserFavorites)
            case .didFinishFetchingUserFavorites(.success(let result)):
                state.currentSearchResults.forEach { productTileItem in
                    if let favorite = result.first(where: { $0.key == productTileItem.id }) {
                        // Add favorite
                        let favoritedProduct = FavoritedProduct(productId: favorite.key, favorite: favorite.value)
                        state.currentSearchResults.replaceFavorite(product: favoritedProduct) { item in
                            var itemClone = item.clone
                            itemClone.favorite = favoritedProduct.favorite
                            return itemClone
                        }
                    } else if let favorite = productTileItem.favorite {
                        // Remove favorite
                        let favoritedProduct = FavoritedProduct(productId: productTileItem.id, favorite: favorite)
                        state.currentSearchResults.replaceFavorite(product: favoritedProduct) { item in
                            var itemClone = item.clone
                            itemClone.favorite = nil
                            return itemClone
                        }
                    }
                }
                return .none
            case .didFinishFetchingUserFavorites(.failure(let error)):
                return .none
            }
        }
    }
}
