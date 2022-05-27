//
//  BankAccount+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/01/2022.
//

import Foundation
import WhoppahModel

extension BankAccountInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.BankAccountInput {
        return .init(accountNumber: self.accountNumber,
                     routingNumber: self.routingNumber,
                     accountHolderName: self.accountHolderName)
    }
}
