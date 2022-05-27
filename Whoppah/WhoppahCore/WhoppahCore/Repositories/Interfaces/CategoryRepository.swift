//
//  CategoryRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 29/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahDataStore

public protocol CategoryRepository {
    var categories: Driver<Result<GraphQL.GetCategoriesQuery.Data?, Error>> { get }
    func load(level: Int)
}
