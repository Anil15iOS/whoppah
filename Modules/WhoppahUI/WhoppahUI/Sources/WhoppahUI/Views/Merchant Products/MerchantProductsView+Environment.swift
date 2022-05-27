//  
//  MerchantProductsView+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import ComposableArchitecture

public extension MerchantProductsView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<MerchantProductsView.Model>
        var trackingClient: WhoppahUI.TrackingClient<MerchantProductsView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<MerchantProductsView.OutboundAction, Effect<MerchantProductsView.Action, Never>>
        var favoritesClient: WhoppahUI.FavoritesClient
        var productsClient: WhoppahUI.ProductsClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<MerchantProductsView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<MerchantProductsView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<MerchantProductsView.OutboundAction, Effect<MerchantProductsView.Action, Never>>,
                    favoritesClient: WhoppahUI.FavoritesClient,
                    productsClient: WhoppahUI.ProductsClient,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.favoritesClient = favoritesClient
            self.productsClient = productsClient
            self.mainQueue = mainQueue
        }
    }
}


public extension MerchantProductsView.Environment {
    static let mock = Self(localizationClient: MerchantProductsView.mockLocalizationClient,
                           trackingClient: MerchantProductsView.mockTrackingClient,
                           outboundActionClient: MerchantProductsView.mockOutboundActionClient,
                           favoritesClient: WhoppahUI.FavoritesClient.mockFavoritesClient,
                           productsClient: WhoppahUI.ProductsClient.mockClient,
                           mainQueue: .main)
}
