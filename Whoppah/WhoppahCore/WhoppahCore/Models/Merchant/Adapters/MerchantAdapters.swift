//
//  MerchantAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

private func isCompliant(_ complianceLevel: Int?) -> Bool {
    guard let level = complianceLevel else { return false }
    return level > 0
}

extension GraphQL.ProductQuery.Data.Product.Merchant: MerchantBasic {
    public var thumbnail: Image? { avatar }
    public var isVerified: Bool { isCompliant(complianceLevel) }
    public var isExpertSeller: Bool? {expertSeller}
}

extension GraphQL.GetMeQuery.Data.Me.Merchant: LegacyMerchant {
    public var address: [WhoppahCore.LegacyAddress] { addresses.map { $0 as WhoppahCore.LegacyAddress } }
    public var avatarImage: Image? { avatar }
    public var coverImage: Image? { cover }
    public var fees: WhoppahCore.Fee? { fee }
    public var bank: WhoppahCore.BankAccount? { bankAccount }
    public var member: [LegacyMember] { [] }
    public var isVerified: Bool { isCompliant(complianceLevel) }
    public var primaryAddress: AddressBasic? { addresses.first }
}

extension GraphQL.GetMerchantQuery.Data.Merchant: LegacyMerchantOther {
    public var avatarImage: Image? { avatar }
    public var coverImage: Image? { cover }
    public var isVerified: Bool { isCompliant(complianceLevel) }
    public var primaryAddress: AddressBasic? { addresses.first }
    public var isExpertSeller: Bool? {expertSeller}
}
