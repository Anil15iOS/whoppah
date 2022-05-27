//
//  Address+Conversion.swift
//  
//
//  Created by Dennis Ippel on 20/01/2022.
//

import Foundation
import WhoppahModel

extension GraphQL.CreateAddressMutation.Data.CreateAddress: WhoppahModelConvertable {
    var toWhoppahModel: Address {
        .init(id: self.id,
              line1: self.line1,
              line2: self.line2,
              postalCode: self.postalCode,
              city: self.city,
              state: self.state,
              country: self.country)
    }
}

extension GraphQL.UpdateAddressMutation.Data.UpdateAddress: WhoppahModelConvertable {
    var toWhoppahModel: Address {
        .init(id: self.id,
              line1: self.line1,
              line2: self.line2,
              postalCode: self.postalCode,
              city: self.city,
              state: self.state,
              country: self.country,
              location: self.location?.toWhoppahModel)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.Address {
    init(_ otherAddress: GraphQL.CreateAddressMutation.Data.CreateAddress) {
        var location: Location? = nil
        
        if let otherLocation = otherAddress.location {
            location = .init(otherLocation)
        }
        
        self.init(title: otherAddress.title,
                  id: otherAddress.id,
                  line1: otherAddress.line1,
                  line2: otherAddress.line2,
                  postalCode: otherAddress.postalCode,
                  city: otherAddress.city,
                  state: otherAddress.state,
                  country: otherAddress.country,
                  location: location)
    }
    
    init(_ otherAddress: GraphQL.UpdateAddressMutation.Data.UpdateAddress) {
        var location: Location? = nil
        
        if let otherLocation = otherAddress.location {
            location = try? .init(otherLocation)
        }
        
        self.init(title: otherAddress.title,
                  id: otherAddress.id,
                  line1: otherAddress.line1,
                  line2: otherAddress.line2,
                  postalCode: otherAddress.postalCode,
                  city: otherAddress.city,
                  state: otherAddress.state,
                  country: otherAddress.country,
                  location: location)
    }
}
