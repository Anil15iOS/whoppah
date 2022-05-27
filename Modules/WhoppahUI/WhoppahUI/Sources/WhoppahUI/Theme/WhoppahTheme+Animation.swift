//
//  WhoppahTheme+Animation.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 06/12/2021.
//

import Foundation
import SwiftUI

public extension WhoppahTheme {
    struct Animation {
        public struct Menu {
            static public let toggleVisibilityDuration: Double = 0.25
        }
        
        public struct Like {
            static public let duration: Double = 0.5
            static public let degrees: Angle = .degrees(180)
            static public let axis: (CGFloat, CGFloat, CGFloat) = (x: 0, y: 1, z: 0)
            static public let perspective: Double = 0
        }
    }
}
