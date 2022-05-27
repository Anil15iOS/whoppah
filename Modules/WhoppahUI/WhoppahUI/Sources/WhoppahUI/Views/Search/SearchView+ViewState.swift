//  
//  SearchView+ViewState.swift
//  
//
//  Created by Dennis Ippel on 09/03/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import WhoppahModel

public extension SearchView {
    struct ViewState: Equatable {
        let id = UUID()
        
        public static func == (lhs: SearchView.ViewState, rhs: SearchView.ViewState) -> Bool {
            return (lhs.id == rhs.id &&
                    lhs.loadingState == rhs.loadingState &&
                    lhs.searchState == rhs.searchState &&
                    lhs.viewState == rhs.viewState &&
                    lhs.currentSearchResults == rhs.currentSearchResults &&
                    lhs.saveSearchState == rhs.saveSearchState &&
                    lhs.loadingSubcategoriesState == rhs.loadingSubcategoriesState &&
                    lhs.latestSearchResultsSet == rhs.latestSearchResultsSet &&
                    lhs.attributesToLoad == rhs.attributesToLoad &&
                    lhs.currentlySelectedProduct == rhs.currentlySelectedProduct &&
                    lhs.model == rhs.model)
        }
        
        public enum ViewState: Equatable {
            case showingSearchResults
            case showingFilters
        }
        
        public enum LoadingState: Equatable {
            case uninitialized
            case loading
            case failed(error: Error)
            case finished
            
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
        
        public enum SaveSearchState: Equatable {
            case uninitialized
            case saving
            case finished
            case failed(error: Error)
            
            public static func == (lhs: Self, rhs: Self) -> Bool {
                switch(lhs, rhs) {
                case (.uninitialized, .uninitialized): return true
                case (.saving, .saving): return true
                case (.finished, .finished): return true
                case (let .failed(lError), let .failed(rError)): return compare(lError, rError)
                default: return false
                }
            }
            
            public var color: SwiftUI.Color {
                switch self {
                case .uninitialized, .failed:
                    return WhoppahTheme.Color.alert3
                default:
                    return WhoppahTheme.Color.base2
                }
            }
            
            public var disablesButton: Bool {
                switch self {
                case .uninitialized, .failed: return false
                default: return true
                }
            }
            
            public var iconName: String {
                switch self {
                case .uninitialized, .failed: return "notification_bell"
                default: return "saved_search_check"
                }
            }
        }
        
        public enum ContentLoadingState: Equatable {
            case uninitialized
            case loadingStaticContent(LoadingState)
            case loadingAttributes(LoadingState)
            case loadingCategories(LoadingState)
            case finished
            
            var failedWithError: Error? {
                switch self {
                case let .loadingStaticContent(.failed(error)): return error
                case let .loadingAttributes(.failed(error)): return error
                case let .loadingCategories(.failed(error)): return error
                default: return nil
                }
            }
            
            var isLoading: Bool {
                switch self {
                case .loadingStaticContent(.loading): return true
                case .loadingAttributes(.loading): return true
                case .loadingCategories(.loading): return true
                default: return false
                }
            }
            
            public static func == (lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case (.uninitialized, .uninitialized):
                    return true
                case (let .loadingStaticContent(lState), let .loadingStaticContent(rState)):
                    return lState == rState
                case (let .loadingAttributes(lState), let .loadingAttributes(rState)):
                    return lState == rState
                case (let .loadingCategories(lState), let .loadingCategories(rState)):
                    return lState == rState
                case (.finished, .finished):
                    return true
                default:
                    return false
                }
            }
        }
        
        var loadingState: ContentLoadingState
        var searchState: LoadingState
        var saveSearchState: SaveSearchState
        var loadingSubcategoriesState: LoadingState
        var viewState: ViewState
        var model: Model
        var currentSearchInput: SearchProductsInput?
        var currentSearchResults = [ProductTileItem]()
        var latestSearchResultsSet: ProductSearchResultsSet?
        var latestSearchFacetsSet = Model.SearchFacetsSet()
        var previewSearchFacetsSet = Model.SearchFacetsSet()
        var attributesToLoad: [AttributeType]
        var currentlySelectedProduct: UUID?
        var visibleSubCategories: [WhoppahModel.Category]? = nil

        public static let initial = Self(loadingState: .uninitialized,
                                         searchState: .uninitialized,
                                         saveSearchState: .uninitialized,
                                         loadingSubcategoriesState: .uninitialized,
                                         viewState: .showingSearchResults,
                                         model: .initial,
                                         attributesToLoad: [.brand, .material, .style, .color])
    }
}
