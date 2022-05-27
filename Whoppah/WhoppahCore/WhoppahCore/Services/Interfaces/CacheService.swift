//
//  CacheService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol CacheService {
    var colors: [Color] { get }
    var colorRepo: AdAttributeRepository? { get }
    var categoryRepo: CategoryRepository? { get }
    var brandRepo: AdAttributeRepository? { get }
    var artistRepo: AdAttributeRepository? { get }
    var designerRepo: AdAttributeRepository? { get }
    var materialRepo: AdAttributeRepository? { get }
}
