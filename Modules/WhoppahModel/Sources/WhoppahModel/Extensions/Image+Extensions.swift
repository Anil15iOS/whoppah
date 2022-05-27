//
//  Image+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 19/04/2022.
//

import Foundation

extension Image: Hashable & Identifiable {
    public static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.id == rhs.id &&
        lhs.url == rhs.url &&
        lhs.type == rhs.type &&
        lhs.orientation == rhs.orientation &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.aspectRatio == rhs.aspectRatio &&
        lhs.position == rhs.position &&
        lhs.backgroundColor == rhs.backgroundColor
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.uuidString)
    }
}
