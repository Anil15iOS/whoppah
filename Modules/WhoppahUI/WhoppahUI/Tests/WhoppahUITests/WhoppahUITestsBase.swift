//
//  WhoppahUITestsBase.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/04/2022.
//

import Foundation
@testable import WhoppahUI
import XCTest

enum MockError: Error {
    case mockError
}

class WhoppahUITestsBase: XCTestCase {
    let defaultSchedulerStride = DispatchQueue.SchedulerTimeType.Stride(floatLiteral: 0.001)
    let scheduler = DispatchQueue.test

    func advance() {
        scheduler.advance(by: defaultSchedulerStride)
    }
}
