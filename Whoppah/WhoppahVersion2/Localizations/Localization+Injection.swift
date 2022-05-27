//
//  Localization+Injection.swift
//  Whoppah
//
//  Created by Dennis Ippel on 21/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import Resolver
import WhoppahModel
import WhoppahLocalization

extension Resolver {
    public static func registerLocalizers() {
        
        ///
        /// 💿 Data store localizers
        ///
        
        lazy var categoryLocalizer: DataStoreLocalizer<WhoppahModel.Category> = {
            WhoppahModel.Category.Localizer()
        }()
        register { categoryLocalizer }
        
        lazy var labelLocalizer: DataStoreLocalizer<WhoppahModel.Label> = {
            WhoppahModel.Label.Localizer()
        }()
        register { labelLocalizer }
        
        lazy var materialLocalizer: DataStoreLocalizer<WhoppahModel.Material> = {
            WhoppahModel.Material.Localizer()
        }()
        register { materialLocalizer }
        
        lazy var styleLocalizer: DataStoreLocalizer<WhoppahModel.Style> = {
            WhoppahModel.Style.Localizer()
        }()
        register { styleLocalizer }
        
        lazy var shippingMethodLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethod> = {
            WhoppahModel.ShippingMethod.Localizer()
        }()
        register { shippingMethodLocalizer }

        lazy var shippingMethodCountryPriceLocalizer: DataStoreLocalizer<WhoppahModel.ShippingMethodCountryPrice> = {
            WhoppahModel.ShippingMethodCountryPrice.Localizer()
        }()
        register { shippingMethodCountryPriceLocalizer }

        ///
        /// 🔢 Enum localizers
        ///

        lazy var auctionStateLocalizer: EnumLocalizer<WhoppahModel.AuctionState> = {
            WhoppahModel.AuctionState.Localizer()
        }()
        register { auctionStateLocalizer }
        
        lazy var countryLocalizer: EnumLocalizer<WhoppahModel.Country> = {
            WhoppahModel.Country.Localizer()
        }()
        register { countryLocalizer }

        lazy var productQualityLocalizer: EnumLocalizer<WhoppahModel.ProductQuality> = {
            WhoppahModel.ProductQuality.Localizer()
        }()
        register { productQualityLocalizer }

        lazy var langLocalizer: EnumLocalizer<WhoppahModel.Lang> = {
            WhoppahModel.Lang.Localizer()
        }()
        register { langLocalizer }

        lazy var abuseReportReasonLocalizer: EnumLocalizer<WhoppahModel.AbuseReportReason> = {
            WhoppahModel.AbuseReportReason.Localizer()
        }()
        register { abuseReportReasonLocalizer }
    }
}
