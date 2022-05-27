//
//  RepositoryFactory.swift
//  WhoppahCore
//
//  Created by Eddie Long on 12/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

public class RepositoryFactory {
    public static func createAdAttributeRepo(type: AttributeType) -> AdAttributeRepository {
        AdAttributeRepositoryImpl(type: type)
    }

    public static func createCategoryRepo() -> CategoryRepository {
        CategoryRepositoryImpl()
    }
}
