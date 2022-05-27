//
//  LegacyShippingMethodsRepo.swift
//  Whoppah
//
//  Created by Eddie Long on 12/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol LegacyShippingMethodsRepository {
    func load(origin: String?, destination: String?) -> Observable<[GraphQL.GetShippingMethodsQuery.Data.ShippingMethod]>
}
