//
//  ProfileAdListRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore

class ProfileAdListRepositoryImpl: ProfileAdListRepository {
    let productRepo: LegacyProductsRepository

    init(productRepo: LegacyProductsRepository) {
        self.productRepo = productRepo
    }
}
