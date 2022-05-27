//
//  Merchant+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

func getMerchantDisplayName(type: GraphQL.MerchantType,
                            businessName: String?,
                            name: String,
                            hideBusinessName: Bool = true) -> String {
    if type != .business {
        return name
    } else if type == .business && !hideBusinessName {
        return businessName ?? ""
    } else {
        return R.string.localizable.ad_details_member_verified()
    }
}

extension LegacyMerchant {
    func getCharacterForAvatarIcon() -> Character? {
        getDisplayName().first
    }

    func getDisplayName() -> String {
        getMerchantDisplayName(type: type,
                               businessName: businessName,
                               name: name)
    }
}

extension LegacyMerchantOther {
    func getCharacterForAvatarIcon() -> Character? {
        getDisplayName().first
    }

    func getDisplayName() -> String {
        getMerchantDisplayName(type: type,
                               businessName: businessName,
                               name: name)
    }
}
