//
//  NSLock.swift
//  WhoppahCore
//
//  Created by Eddie Long on 30/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension NSLock {
    public typealias SyncBlock = (() -> Void)
    public func sync(_ block: SyncBlock) {
        lock()
        block()
        unlock()
    }
}
