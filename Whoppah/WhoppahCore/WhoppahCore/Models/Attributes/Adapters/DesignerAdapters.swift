//
//  DesignerAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Attribute.AsDesigner: Designer {}
extension GraphQL.GetAttributesQuery.Data.AttributesByKey.AsDesigner: Designer {}
extension GraphQL.SearchQuery.Data.Search.Attribute.Item.Attribute.AsDesigner: Designer {}
