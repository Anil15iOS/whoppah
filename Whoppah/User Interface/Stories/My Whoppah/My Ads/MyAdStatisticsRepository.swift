//
//  MyAdStatisticsRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 11/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol MyAdStatisticsRepository {
    var productDetails: Observable<GraphQL.ProductQuery.Data.Product?> { get }
    func watchProduct(id: UUID)
}
