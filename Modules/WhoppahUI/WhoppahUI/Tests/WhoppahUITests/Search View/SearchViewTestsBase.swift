//
//  SearchViewTestsBase.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/04/2022.
//

import Foundation
import XCTest
@testable import WhoppahUI
import WhoppahModel
import ComposableArchitecture

class SearchViewTestsBase: WhoppahUITestsBase {
    
    lazy var mockModel: SearchView.Model = {
        SearchView.Model.mock
    }()
    
    var randomQuery: String {
        RandomWord.randomWords(1...3)
    }
    
    var randomSortingOption: SearchView.Model.Filters.SortingOption {
        mockModel.filters.sortingOptions.randomElement() ?? .default
    }
    
    lazy var viewStore: ViewStore<SearchView.ViewState, SearchView.Action> = {
        let store = Store(
            initialState: .initial,
            reducer: SearchView.Reducer().reducer,
            environment: mockEnvironment)
        
        return ViewStore(store)
    }()
    
    lazy var mockEnvironment: SearchView.Environment = {
        SearchView.Environment(
            localizationClient: SearchView.mockLocalizationClient,
            trackingClient: SearchView.mockTrackingClient,
            outboundActionClient: SearchView.mockOutboundActionClient,
            searchClient: WhoppahUI.SearchClient.mockClient,
            attributesClient: WhoppahUI.AttributesClient.mockClient,
            categoriesClient: WhoppahUI.CategoriesClient.mockCategoriesClient,
            favoritesClient: WhoppahUI.FavoritesClient.mockFavoritesClient,
            mainQueue: scheduler.eraseToAnyScheduler())
    }()
}
