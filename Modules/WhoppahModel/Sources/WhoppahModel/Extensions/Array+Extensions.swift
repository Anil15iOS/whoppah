//
//  Array+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 11/04/2022.
//

import Foundation

public extension Array where Element: ChildrenContainable {
    var flattened: [Element] {
        var myArray = [Element]()
        for element in self {
            myArray.append(element)
            if let children = element.children as? [Element] {
                myArray += children.flattened
            }
        }
        return myArray
    }
}
