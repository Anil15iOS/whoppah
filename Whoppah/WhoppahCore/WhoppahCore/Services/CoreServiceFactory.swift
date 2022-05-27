//
//  CoreServiceFactory.swift
//  WhoppahCore
//
//  Created by Eddie Long on 12/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

public class CoreServiceFactory {
    public static func createCacheService() -> CacheService {
        CacheServiceImpl()
    }
}
