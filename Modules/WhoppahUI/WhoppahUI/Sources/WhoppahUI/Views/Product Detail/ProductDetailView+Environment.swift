//  
//  ProductDetailView+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import ComposableArchitecture

public extension ProductDetailView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<ProductDetailView.Model>
        var trackingClient: WhoppahUI.TrackingClient<ProductDetailView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<ProductDetailView.OutboundAction, Effect<ProductDetailView.Action, Never>>
        var productDetailsClient: WhoppahUI.ProductDetailsClient
        var favoritesClient: WhoppahUI.FavoritesClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<ProductDetailView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<ProductDetailView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<ProductDetailView.OutboundAction, Effect<ProductDetailView.Action, Never>>,
                    productDetailsClient: WhoppahUI.ProductDetailsClient,
                    favoritesClient: WhoppahUI.FavoritesClient,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.productDetailsClient = productDetailsClient
            self.favoritesClient = favoritesClient
            self.mainQueue = mainQueue
        }
    }
}


public extension ProductDetailView.Environment {
    static let mock = Self(localizationClient: ProductDetailView.mockLocalizationClient,
                           trackingClient: ProductDetailView.mockTrackingClient,
                           outboundActionClient: ProductDetailView.mockOutboundActionClient,
                           productDetailsClient: .mockClient,
                           favoritesClient: WhoppahUI.FavoritesClient.mockFavoritesClient,
                           mainQueue: .main)
}
