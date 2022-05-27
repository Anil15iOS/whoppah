//
//  Merchant.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

// Other user merchant
public protocol LegacyMerchantOther {
    var id: UUID { get }
    var name: String { get }
    var businessName: String? { get }
    var created: DateTime { get }
    var type: GraphQL.MerchantType { get }
    var biography: String? { get }
    var url: String? { get }
    var avatarImage: Image? { get }
    var coverImage: Image? { get }
    var isVerified: Bool { get }
    var primaryAddress: AddressBasic? { get }
}

// User's merchant
public protocol LegacyMerchant: LegacyMerchantOther {
    var id: UUID { get }
    var name: String { get }
    var businessName: String? { get }
    var email: String? { get }
    var phone: String? { get }
    var type: GraphQL.MerchantType { get }
    var biography: String? { get }
    var vatId: String? { get }
    var taxId: String? { get }
    var url: String? { get }
    var avatarImage: Image? { get }
    var currency: GraphQL.Currency { get }
    var coverImage: Image? { get }
    var address: [LegacyAddress] { get }
    var bank: BankAccount? { get }
    var fees: Fee? { get }
    var isVerified: Bool { get }
    var member: [LegacyMember] { get }
    var vatRate: Double { get }
}

extension LegacyMerchant {
    public var vatRate: Double { 21.0 }
}

public struct LegacyMerchantInput {
    public var type: GraphQL.MerchantType
    public var id: UUID
    public var email: String?
    public var name: String
    public var businessName: String?
    public var url: String?
    public var vatId: String?
    public var taxId: String?
    public var phone: String?
    public var biography: String?
    public var avatar: URL?

    public init(merchant: LegacyMerchant) {
        id = merchant.id
        type = merchant.type
        name = merchant.name
        businessName = merchant.businessName
        url = merchant.url
        email = merchant.email
        phone = merchant.phone
        biography = merchant.biography
        vatId = merchant.vatId
        taxId = merchant.taxId
        if let url = merchant.avatarImage?.url, let avatar = URL(string: url) {
            self.avatar = avatar
        }
    }
}
