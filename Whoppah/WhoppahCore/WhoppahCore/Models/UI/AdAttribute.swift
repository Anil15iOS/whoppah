//
//  AdAttribute.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var slug: String { get }
    var description: String? { get }
}

public struct AdAttributeInput: AdAttribute {
    public let id: UUID
    public let title: String
    public let slug: String
    public let description: String?

    public init(id: UUID, title: String, slug: String, description: String?) {
        self.id = id
        self.title = title
        self.slug = slug
        self.description = description
    }
}

public let uniqueCustomAttributeSlug = UUID().uuidString
public let unknownAttributeSlug = UUID().uuidString
