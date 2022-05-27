//
//  UserAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetMeQuery.Data.Me: LegacyMember {
    public var merchant: [WhoppahCore.LegacyMerchant] { merchants.map { $0 } }
}
