//
//  Merchant+Conversion.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation
import WhoppahModel
import CoreLocation

extension GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location: WhoppahModelConvertable {
    var toWhoppahModel: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.Address: WhoppahModelConvertable {
    var toWhoppahModel: Address {
        return Address(id: self.id,
                       line1: self.line1,
                       line2: self.line2,
                       postalCode: self.postalCode,
                       city: self.city,
                       state: self.state,
                       country: self.country,
                       location: self.location?.toWhoppahModel)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.BankAccount: WhoppahModelConvertable {
    var toWhoppahModel: BankAccount {
        return BankAccount(accountNumber: self.accountNumber,
                           routingNumber: self.routingNumber,
                           accountHolderName: self.accountHolderName)
    }
}
                
extension GraphQL.GetMeQuery.Data.Me.Merchant.Fee: WhoppahModelConvertable {
    var toWhoppahModel: Fee {
        return Fee(type: self.type.toWhoppahModel,
                   amount: self.amount)
    }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant: WhoppahModelConvertable {
    var toWhoppahModel: Merchant {
        let addresses = self.addresses.map { $0.toWhoppahModel }
        
        let merchant = Merchant(
            id: self.id,
            type: self.type.toWhoppahModel,
            name: self.name,
            slug: "",
            created: self.created.toWhoppahModel,
            biography: self.biography,
            url: self.url,
            phone: self.phone,
            email: self.email,
            businessName: self.businessName,
            taxId: self.taxId,
            vatId: self.vatId,
            complianceLevel: self.complianceLevel,
            fee: self.fee?.toWhoppahModel,
            currency: self.currency.toWhoppahModel,
            bankAccount: self.bankAccount?.toWhoppahModel,
            addresses: addresses,
            members: [],
            images: [],
            videos: [],
            favorites: [],
            favoritecollections: [],
            rawObject: self as AnyObject)
            
//            avatarImage: self.avatar?.toWhoppahModel,
            
//            coverImage: self.cover?.toWhoppahModel,
        return merchant
    }
}
