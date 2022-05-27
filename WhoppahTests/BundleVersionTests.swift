//
//  BundleVersionTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 11/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import XCTest

@testable import Testing_Debug
@testable import WhoppahCore

class BundleVersionTests: XCTestCase {

    func testSimpleVersion() {
        // given
        let major = 1
        let minor = 2
        let patch = 3
        let versionStr = "\(major).\(minor).\(patch)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNotNil(version)
        XCTAssertEqual(version!.major, major)
        XCTAssertEqual(version!.minor, minor)
        XCTAssertEqual(version!.patch, patch)
    }

    func testSimpleVersionExtra() {
        // given
        let major = 1
        let minor = 2
        let patch = 3
        let patch_extra = 4 // ignored
        let versionStr = "\(major).\(minor).\(patch).\(patch_extra)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNotNil(version)
        XCTAssertEqual(version!.major, major)
        XCTAssertEqual(version!.minor, minor)
        XCTAssertEqual(version!.patch, patch)
    }

    func testVersionMissingMajor() {
        // given
        let minor = 2
        let patch = 3
        let versionStr = "\(minor).\(patch)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNil(version)
    }

    func testVersionMissingMinor() {
        // given
        let major = 1
        let patch = 3
        let versionStr = "\(major).\(patch)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNil(version)
    }

    func testVersionMissingMinorPatch() {
        // given
        let major = 1
        let versionStr = "\(major)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNil(version)
    }

    func testBadSeparatorVersion() {
        // given
        let major = 1
        let minor = 2
        let patch = 3
        let versionStr = "\(major)-\(minor)-\(patch)"

        // when
        let version = Bundle.getVersion(forString: versionStr)

        // then
        XCTAssertNil(version)
    }

    func testAlphaNumbericVersion() {
       // given
       let major = 1
       let minor = 2
       let patch = 3
       let versionStr = "\(major)-\(minor)-\(patch)beta"

       // when
       let version = Bundle.getVersion(forString: versionStr)

       // then
       XCTAssertNil(version)
   }
}
