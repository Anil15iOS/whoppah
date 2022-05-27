//
//  MerchantInput+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/01/2022.
//

import Foundation
import WhoppahModel

extension MerchantInput: GraphQLModelConvertable {
    var toGraphQLModel: GraphQL.MerchantInput {
        return GraphQL.MerchantInput(type: self.type.toGraphQLModel,
                                     name: self.name,
                                     biography: self.biography,
                                     url: self.url,
                                     phone: self.phone,
                                     email: self.email,
                                     businessName: self.businessName,
                                     taxId: self.taxId,
                                     vatId: self.vatId)
    }
}
