//
//  AddressInput+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/01/2022.
//

import Foundation
import WhoppahModel

extension AddressInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.AddressInput {
        return .init(merchantId: self.id ?? UUID(),
                     line1: self.line1,
                     line2: self.line2,
                     postalCode: self.postalCode,
                     city: self.city,
                     state: self.state,
                     country: self.country,
                     location: self.location?.toGraphQLModel)
    }
}

extension GraphQL.SignupAddressInput {
    init(_ otherAddressInput: GraphQL.AddressInput) {
        self.init(line1: otherAddressInput.line1,
                  line2: otherAddressInput.line2,
                  postalCode: otherAddressInput.postalCode,
                  city: otherAddressInput.city,
                  state: otherAddressInput.state,
                  country: otherAddressInput.country,
                  location: otherAddressInput.location)
    }
}
