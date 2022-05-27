//
//  ARScene.swift
//  Whoppah
//
//  Created by Eddie Long on 23/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct ARScene {
    public let allowsRotation: Bool
    public let allowsPan: Bool
    public enum Alignment {
        case vertical
        case horizontal
    }

    public var alignments: [Alignment] = [.vertical, .horizontal]

    public let objects: [ARAsset]

    public init(allowsRotation: Bool, allowsPan: Bool, alignments: [Alignment], objects: [ARAsset]) {
        self.allowsRotation = allowsRotation
        self.allowsPan = allowsPan
        self.alignments = alignments
        self.objects = objects
    }
}
