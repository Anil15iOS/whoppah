//
//  ARAsset.swift
//  Whoppah
//
//  Created by Eddie Long on 23/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct ARAsset {
    public let ID: UUID
    public let type: ARType

    public init(ID: UUID, type: ARType) {
        self.ID = ID
        self.type = type
    }
}
