//
//  WhoppahTestBase.swift
//  WhoppahNextTests
//
//  Created by Dennis Ippel on 03/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import XCTest

class WhoppahTestBase: XCTestCase {
    let defaultSchedulerStride = DispatchQueue.SchedulerTimeType.Stride(floatLiteral: 0.001)
    let scheduler = DispatchQueue.test
    
    enum TestError: Error {
        case mockError
    }
    
    func advance() {
        scheduler.advance(by: defaultSchedulerStride)
    }
}
