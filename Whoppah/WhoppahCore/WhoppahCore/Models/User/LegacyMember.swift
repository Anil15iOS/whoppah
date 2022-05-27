//
//  Member.swift
//  WhoppahCore
//
//  Created by Eddie Long on 02/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol LegacyMember {
    var id: UUID { get }
    var givenName: String { get }
    var familyName: String { get }
    var email: String { get }
    var dateJoined: DateTime { get }
    var dob: Date? { get }
    var locale: GraphQL.Locale { get }
    var merchant: [LegacyMerchant] { get }
}

public struct LegacyMemberInput {
    public var id: UUID?
    public var givenName: String?
    public var familyName: String?
    public var email: String?
    public var dob: Date?
    public var locale = GraphQL.Locale.nlNl

    public init(email: String?, givenName: String?, familyName: String?) {
        self.email = email
        self.givenName = givenName
        self.familyName = familyName
    }

    public init(member: LegacyMember) {
        id = member.id
        email = member.email
        givenName = member.givenName
        familyName = member.familyName
        dob = member.dob
        locale = member.locale
    }
}

extension LegacyMember {
    public var isProfessional: Bool { mainMerchant.type == .business }
    public var mainMerchant: LegacyMerchant { merchant.first! }
    public var merchantId: UUID { mainMerchant.id }
}
