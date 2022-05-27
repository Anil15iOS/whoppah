//
//  CategoryAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Category.Parent.Parent: CategoryBasic {
    public var ancestor: CategoryBasic? { nil }
}

extension GraphQL.ProductQuery.Data.Product.Category.Parent: CategoryBasic {
    public var ancestor: CategoryBasic? { parent }
}

extension GraphQL.ProductQuery.Data.Product.Category: CategoryBasic {
    public var ancestor: CategoryBasic? { parent }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Parent: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { [] }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { items.compactMap { $0 } }
    public var image: [Image] { media.compactMap { $0.asImage } }
    public var detailImages: [Image] {
        guard let image = detailImage else { return [] }
        return [image]
    }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item: Category {
    public var ancestor: Category? { parent }
    public var children: [Category] { items.compactMap { $0 } }
    public var image: [Image] { media.compactMap { $0.asImage } }
    public var detailImages: [Image] { [] }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Item.Parent: Category {
    public var ancestor: Category? { parent }
    public var children: [Category] { [] }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Item.Parent.Parent: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { [] }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}

extension GraphQL.GetCategoriesQuery.Data.Category.Item.Item.Item: Category {
    public var ancestor: Category? { parent }
    public var children: [Category] { [] }
    public var image: [Image] { media.compactMap { $0.asImage } }
    public var detailImages: [Image] { [] }
}

extension GraphQL.SearchQuery.Data.Search.Category.Item: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { items.compactMap { $0 }.map { $0 } }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}

extension GraphQL.SearchQuery.Data.Search.Category.Item.Item: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { items.compactMap { $0 }.map { $0 } }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}

extension GraphQL.SearchQuery.Data.Search.Category.Item.Item.Item: Category {
    public var ancestor: Category? { nil }
    public var children: [Category] { [] }
    public var image: [Image] { [] }
    public var detailImages: [Image] { [] }
}
