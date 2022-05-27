//
//  AssociatedObject.swift
//  Whoppah
//
//  Created by Eddie Long on 07/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol AssociatedObject: AnyObject {}

extension AssociatedObject {
    /// wrapper around `objc_getAssociatedObject`
    public func ao_get<T>(pkey: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, pkey) as? T
    }

    /// wrapper around `objc_setAssociatedObject`
    public func ao_set<T>(_ value: T, pkey: UnsafeRawPointer) {
        objc_setAssociatedObject(self, pkey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension NSObject: AssociatedObject {}
