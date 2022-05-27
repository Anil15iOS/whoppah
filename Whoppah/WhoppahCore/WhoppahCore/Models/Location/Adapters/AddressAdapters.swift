//
//  AddressAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Address.Location: Point {}
extension GraphQL.ProductQuery.Data.Product.Address: LegacyAddress {
    public var point: WhoppahCore.Point? { location }
}

extension GraphQL.GetMerchantAddressesQuery.Data.Merchant.Address.Location: Point {}
extension GraphQL.GetMerchantAddressesQuery.Data.Merchant.Address: LegacyAddress {
    public var point: WhoppahCore.Point? { location }
}

extension GraphQL.CreateAddressMutation.Data.CreateAddress.Location: Point {}
extension GraphQL.CreateAddressMutation.Data.CreateAddress: LegacyAddress {
    public var point: WhoppahCore.Point? { location }
}

extension GraphQL.UpdateAddressMutation.Data.UpdateAddress.Location: Point {}
extension GraphQL.UpdateAddressMutation.Data.UpdateAddress: LegacyAddress {
    public var point: WhoppahCore.Point? { location }
}

extension GraphQL.GetMeQuery.Data.Me.Merchant.Address.Location: Point {}
extension GraphQL.GetMeQuery.Data.Me.Merchant.Address: LegacyAddress {
    public var point: WhoppahCore.Point? { location }
}

extension GraphQL.GetMerchantQuery.Data.Merchant.Address: AddressBasic {
    public var point: Point? { nil }
}
