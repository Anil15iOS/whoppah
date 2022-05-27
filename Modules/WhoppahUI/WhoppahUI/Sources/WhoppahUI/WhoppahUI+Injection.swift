//
//  WhoppahUI+Injection.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 21/03/2022.
//

import Foundation
import Resolver
import WhoppahLocalization
import WhoppahModel

extension WhoppahUI {
    public static func registerMockLocalizers() {
        lazy var categoryMockLocalizer: DataStoreLocalizer<WhoppahModel.Category> = {
            WhoppahModel.Category.MockLocalizer()
        }()
        Resolver.register { categoryMockLocalizer }

        lazy var labelMockLocalizer: DataStoreLocalizer<WhoppahModel.Label> = {
            WhoppahModel.Label.MockLocalizer()
        }()
        Resolver.register { labelMockLocalizer }
        
        lazy var materialMockLocalizer: DataStoreLocalizer<WhoppahModel.Material> = {
            WhoppahModel.Material.MockLocalizer()
        }()
        Resolver.register { materialMockLocalizer }
        
        lazy var styleMockLocalizer: DataStoreLocalizer<WhoppahModel.Style> = {
            WhoppahModel.Style.MockLocalizer()
        }()
        Resolver.register { styleMockLocalizer }
        
        lazy var auctionStateMockLocalizer: EnumLocalizer<WhoppahModel.AuctionState> = {
            WhoppahModel.AuctionState.MockLocalizer()
        }()
        Resolver.register { auctionStateMockLocalizer }
        
        lazy var countryMockLocalizer: EnumLocalizer<WhoppahModel.Country> = {
            WhoppahModel.Country.MockLocalizer()
        }()
        Resolver.register { countryMockLocalizer }
        
        lazy var productQualityMockLocalizer: EnumLocalizer<WhoppahModel.ProductQuality> = {
            WhoppahModel.ProductQuality.MockLocalizer()
        }()
        Resolver.register { productQualityMockLocalizer }
        
        lazy var shippingMethodMockLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethod> = {
            WhoppahModel.ShippingMethod.MockLocalizer()
        }()
        Resolver.register { shippingMethodMockLocalizer }
        
        lazy var shippingMethodCountryPriceMockLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethodCountryPrice> = {
            WhoppahModel.ShippingMethodCountryPrice.MockLocalizer()
        }()
        Resolver.register { shippingMethodCountryPriceMockLocalizer }
        
        lazy var langMockLocalizer: EnumLocalizer<WhoppahModel.Lang> = {
            WhoppahModel.Lang.MockLocalizer()
        }()
        Resolver.register { langMockLocalizer }
        
        lazy var abuseReportReasonMockLocalizer: EnumLocalizer<WhoppahModel.AbuseReportReason> = {
            WhoppahModel.AbuseReportReason.MockLocalizer()
        }()
        Resolver.register { abuseReportReasonMockLocalizer }
    }
}
