//
//  BrandAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Attribute.AsBrand: BrandAttribute {}
extension GraphQL.GetAttributesQuery.Data.AttributesByKey.AsBrand: BrandAttribute {}
extension GraphQL.SearchQuery.Data.Search.Attribute.Item.Attribute.AsBrand: BrandAttribute {}
