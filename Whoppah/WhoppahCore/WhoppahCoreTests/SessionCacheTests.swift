//
//  SessionCacheTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 17/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

@testable import Testing_Debug

class SessionCacheTests: XCTestCase {
    func testSessionCacheDefaults() {
        let cache = CacheServiceImpl.SessionCache<Int>.init(policy: .eternal)
        // always nil by defailt
        XCTAssertNil(cache.get())
    }

    func testEternalPolicySessionCache() {
        let cache = CacheServiceImpl.SessionCache<Int>(policy: .eternal)
        let value = 100
        cache.set(value: value)
        let cachedvalue = cache.get()
        XCTAssertNotNil(cachedvalue)
        XCTAssertEqual(cachedvalue, value)

        // Cache is always there, regardless of times
        let exp = expectation(description: "eternal_wait")
        exp.isInverted = true
        waitForExpectations(timeout: 2) { _ in
            let cachedvalue = cache.get()
            XCTAssertNotNil(cachedvalue)
            XCTAssertEqual(cachedvalue, value)

            cache.clear()
            XCTAssertNil(cache.get())
        }
    }

    func testNonePolicySessionCache() {
        let cache = CacheServiceImpl.SessionCache<Int>(policy: .none)
        // Nothing is ever cached
        XCTAssertNil(cache.get())
        cache.set(value: 100)
        XCTAssertNil(cache.get())
    }

    func testExpiredPolicySessionCache() {
        let cache = CacheServiceImpl.SessionCache<Int>(policy: .expirable(durationSeconds: 5))
        let value = 100
        cache.set(value: value)
        let cachedvalue = cache.get()
        XCTAssertNotNil(cachedvalue)
        XCTAssertEqual(cachedvalue, value)

        // Cache not expired yet
        let exp = expectation(description: "expiry_wait")
        exp.isInverted = true
        waitForExpectations(timeout: 2) { _ in
            let cachedvalue = cache.get()
            XCTAssertNotNil(cachedvalue)
            XCTAssertEqual(cachedvalue, value)
        }

        // Cache has expired
        let exp2 = expectation(description: "expiry_wait_2")
        exp2.isInverted = true
        waitForExpectations(timeout: 4) { _ in
            let cachedvalue = cache.get()
            XCTAssertNil(cachedvalue)
        }
    }
}
