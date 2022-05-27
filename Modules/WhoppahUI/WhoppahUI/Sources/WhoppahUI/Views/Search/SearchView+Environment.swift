//  
//  SearchView+Environment.swift
//  
//
//  Created by Dennis Ippel on 09/03/2022.
//

import ComposableArchitecture

public extension SearchView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<SearchView.Model>
        var trackingClient: WhoppahUI.TrackingClient<SearchView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<SearchView.OutboundAction, Effect<SearchView.Action, Never>>
        var searchClient: WhoppahUI.SearchClient
        var attributesClient: WhoppahUI.AttributesClient
        var categoriesClient: WhoppahUI.CategoriesClient
        var favoritesClient: WhoppahUI.FavoritesClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<SearchView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<SearchView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<SearchView.OutboundAction, Effect<SearchView.Action, Never>>,
                    searchClient: WhoppahUI.SearchClient,
                    attributesClient: WhoppahUI.AttributesClient,
                    categoriesClient: WhoppahUI.CategoriesClient,
                    favoritesClient: WhoppahUI.FavoritesClient,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.searchClient = searchClient
            self.attributesClient = attributesClient
            self.categoriesClient = categoriesClient
            self.favoritesClient = favoritesClient
            self.mainQueue = mainQueue
        }
    }
}


public extension SearchView.Environment {
    static let mock = Self(localizationClient: SearchView.mockLocalizationClient,
                           trackingClient: SearchView.mockTrackingClient,
                           outboundActionClient: SearchView.mockOutboundActionClient,
                           searchClient: WhoppahUI.SearchClient.mockClient,
                           attributesClient: WhoppahUI.AttributesClient.mockClient,
                           categoriesClient: WhoppahUI.CategoriesClient.mockCategoriesClient,
                           favoritesClient: WhoppahUI.FavoritesClient.mockFavoritesClient,
                           mainQueue: .main)
}
