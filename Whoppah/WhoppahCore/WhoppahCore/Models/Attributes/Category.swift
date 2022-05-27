//
//  Category.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public func categoryTitleKey(_ slug: String) -> String {
    "category-\(slug)"
}

public protocol Category: AdAttribute {
    var id: UUID { get }
    var ancestor: Category? { get }
    var children: [Category] { get }
    var title: String { get }
    var slug: String { get }
    var image: [Image] { get }
    var detailImages: [Image] { get }
    var description: String? { get }
}

extension Category {
    public var title: String {
        categoryTitleKey(slug)
    }
}

public protocol CategoryBasic: AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var slug: String { get }
    var ancestor: CategoryBasic? { get }
    var description: String? { get }
}

extension CategoryBasic {
    public var ancestor: CategoryBasic? { nil }
}

extension CategoryBasic {
    public var title: String {
        categoryTitleKey(slug)
    }
}
