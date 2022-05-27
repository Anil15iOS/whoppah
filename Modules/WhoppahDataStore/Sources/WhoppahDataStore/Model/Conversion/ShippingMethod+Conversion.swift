//
//  ShippingMethod+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 01/05/2022.
//

import Foundation
import WhoppahModel

extension GraphQL.GetShippingMethodsQuery.Data.ShippingMethod.Price: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.Price {
        .init(amount: self.amount, currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.GetShippingMethodsQuery.Data.ShippingMethod: WhoppahModelConvertable {
    var toWhoppahModel: WhoppahModel.ShippingMethod {
        .init(id: self.id,
              title: "",
              description: nil,
              slug: self.slug,
              price: self.price.toWhoppahModel)
    }
}
