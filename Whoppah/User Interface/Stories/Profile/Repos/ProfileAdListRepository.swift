//
//  ProfileAdListRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

protocol ProfileAdListRepository {
    var productRepo: LegacyProductsRepository { get }
}
