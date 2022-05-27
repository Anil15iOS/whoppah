//
//  LegacyARObject.swift
//  WhoppahCore
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public enum ARType {
    case plane(url: URL, size: [Double])
    case object(url: URL)
}

public protocol LegacyARObject {
    var id: UUID { get }
    var allowsPan: Bool { get }
    var allowsRotation: Bool { get }
    var detection: GraphQL.ARDetection { get }
    var image: URL? { get }
    var downloadUrl: URL? { get }
}

public func getARType(_ object: LegacyARObject?, size: [Int?]) -> ARType? {
    guard let object = object else { return nil }
    let sizeMetres = size.compactMap { $0 }.map { Double($0) / 100.0 }
    if let image = object.downloadUrl, sizeMetres.count == 2 {
        return .plane(url: image, size: sizeMetres)
    }
    return nil
}
