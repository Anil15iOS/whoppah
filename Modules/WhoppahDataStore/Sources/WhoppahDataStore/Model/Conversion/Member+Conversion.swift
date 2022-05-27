//
//  Member+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation
import WhoppahModel

extension GraphQL.GetMeQuery.Data.Me: WhoppahModelConvertable {
    var toWhoppahModel: Member {
        let merchants = self.merchants.map { $0.toWhoppahModel }

        var member = Member(
            id: self.id,
            email: self.email,
            givenName: self.givenName,
            familyName: self.familyName,
            dateJoined: self.dateJoined.date,
            locale: self.locale.toWhoppahModel,
            dob: self.dob,
            merchants: merchants)
        member.rawObject = self as AnyObject
        return member
    }
}
