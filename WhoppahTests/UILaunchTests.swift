//
//  UILaunchTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 29/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import XCTest

class UILaunchTests: XCTestCase {
  func testLaunchPerformance() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
        XCUIApplication().launch()
      }
    }
  }
}
