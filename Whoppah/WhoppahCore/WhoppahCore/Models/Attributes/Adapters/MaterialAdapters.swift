//
//  ProductDetailsMaterialAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Attribute.AsMaterial: Material {}
extension GraphQL.GetAttributesQuery.Data.AttributesByKey.AsMaterial: Material {}
extension GraphQL.SearchQuery.Data.Search.Attribute.Item.Attribute.AsMaterial: Material {}
