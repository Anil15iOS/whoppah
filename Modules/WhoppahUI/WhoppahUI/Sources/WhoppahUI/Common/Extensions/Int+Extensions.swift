//
//  File.swift
//  
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation
import Focuser

extension Int: FocusStateCompliant {
    static public var last: Int = 0
    public var next: Int? {
        return self + 1
    }
}
