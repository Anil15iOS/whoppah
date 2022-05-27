//
//  ArtistAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Attribute.AsArtist: Artist {}
extension GraphQL.GetAttributesQuery.Data.AttributesByKey.AsArtist: Artist {}
extension GraphQL.SearchQuery.Data.Search.Attribute.Item.Attribute.AsArtist: Artist {}
