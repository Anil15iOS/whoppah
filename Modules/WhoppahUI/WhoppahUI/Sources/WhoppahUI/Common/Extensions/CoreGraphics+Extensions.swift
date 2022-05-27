//
//  CoreGraphics+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/05/2022.
//

import Foundation
import CoreGraphics
import simd

public extension CGSize {
    var toSIMD: SIMD2<Float> {
        [Float(width), Float(height)]
    }
}

public func *(left: CGSize, right: CGFloat) -> CGSize {
    .init(width: left.width * right, height: left.height * right)
}
