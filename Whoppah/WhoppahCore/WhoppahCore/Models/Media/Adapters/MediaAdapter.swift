//
//  GetProductImageAdapter.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Medium.AsImage: Image {}
extension GraphQL.GetCategoriesQuery.Data.Category.Item.DetailImage: Image {}
extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Medium.AsImage: Image {}
extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Item.Medium.AsImage: Image {}
extension GraphQL.ProductQuery.Data.Product.FullImage: Image {}
extension GraphQL.ProductQuery.Data.Product.Thumbnail: Image {}
extension GraphQL.ProductQuery.Data.Product.Merchant.Avatar: Image {}
extension GraphQL.GetMerchantQuery.Data.Merchant.Avatar: Image {}
extension GraphQL.GetMerchantQuery.Data.Merchant.Cover: Image {}
extension GraphQL.GetMeQuery.Data.Me.Merchant.Avatar: Image {}
extension GraphQL.GetMeQuery.Data.Me.Merchant.Cover: Image {}

extension GraphQL.ProductQuery.Data.Product.Video: Video {}
