//
//  StaticContentLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 22/03/2022.
//

import Foundation

public protocol StaticContentLocalizable {
    associatedtype ContentType
    
    static var localized: ContentType { get }
}
