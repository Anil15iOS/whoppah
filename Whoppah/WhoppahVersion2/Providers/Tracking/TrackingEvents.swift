//
//  TrackingEvents.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation

enum TrackingEvents {
    enum UserRole: String {
        case personal
        case merchant
    }

    enum TransportType: String {
        case pickUp = "ophalen"
        case delivery = "bezorgen"
        case courier = "brenger_koerier_service"
    }

    enum PageSource: String {
        case search = "search_results"
        case favorites
        case home = "homepage"
        case looks
        case adDetails = "pdp"
        case profile = "public_profile"
        case adStats = "ad_stats"
    }

    enum BuyNowSource: String {
        case pdp = "PDP_View"
        case ar = "AR_View"
    }

    enum BidSource: String {
        case ar = "AR_View"
        case pdp = "PDP_View"
        case pdpNoBidYet = "PDP_NoBidYet"
    }
    
//    enum Ad {
//        case shareClicked(ad: ProductDetails)
//        case shareCompleted(ad: ProductDetails, shareNetwork: String)
//        case showAllSimilarItems(ad: ProductDetails)
//        case safeShoppingBannerClicked
//    }

}
