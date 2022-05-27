//
//  ColorAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Attribute.AsColor: Color {}
extension GraphQL.GetAttributesQuery.Data.AttributesByKey.AsColor: Color {}
extension GraphQL.SearchQuery.Data.Search.Attribute.Item.Attribute.AsColor: Color {}
