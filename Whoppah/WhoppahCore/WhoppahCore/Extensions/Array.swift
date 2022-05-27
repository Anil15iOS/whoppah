//
//  Array.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension Array {
    public var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }

    @discardableResult
    public mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }

    public var chooseOne: Element {
        self[Int(arc4random_uniform(UInt32(count)))]
    }

    public func choose(_ number: Int) -> Array {
        Array(shuffled.prefix(number))
    }
}

extension Array where Element: Equatable {
    public mutating func remove(_ element: Element) {
        self = filter { $0 != element }
    }
}

extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
