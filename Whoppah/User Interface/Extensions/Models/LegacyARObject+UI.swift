//
//  LegacyARObject+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

extension LegacyARObject {
    var alignments: [ARScene.Alignment] {
        switch detection {
        case .horizontal:
            return [.horizontal]
        case .vertical:
            return [.vertical]
        case .verticalAndHorizontal:
            return [.horizontal, .vertical]
        default:
            return [.horizontal, .vertical]
        }
    }
}
