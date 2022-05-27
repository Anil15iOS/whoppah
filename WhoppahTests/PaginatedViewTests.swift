//
//  PaginatedViewTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 13/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

@testable import Testing_Debug
@testable import WhoppahCore

class PaginatedViewTests: XCTestCase {

    func testPaginatedViewDefaults() {
        let pv = PagedView(pageSize: 10)
        XCTAssertEqual(pv.nextPage, 1)
        XCTAssertEqual(pv.pageSize, 10)
        XCTAssertEqual(pv.currentPage, 1)
        XCTAssertFalse(pv.hasMorePages())
        XCTAssertTrue(pv.isFirstPage())
    }

    func testPagedViewDepth() {
        var pv = PagedView(pageSize: 10)
        pv.onListFetched(page: 1, total: 2, limit: 10)
        XCTAssertEqual(pv.currentDepth, 10)
        XCTAssertEqual(pv.currentPage, 1)
        XCTAssertEqual(pv.nextPage, 2)
        XCTAssertTrue(pv.isFirstPage())
        XCTAssertTrue(pv.hasMorePages())
        pv.onListFetched(page: 2, total: 2, limit: 40)
        XCTAssertEqual(pv.currentPage, 2)
        XCTAssertEqual(pv.nextPage, 2)
        XCTAssertEqual(pv.currentDepth, 50)
        XCTAssertFalse(pv.hasMorePages())
        XCTAssertFalse(pv.isFirstPage())

    }

    func testPagedViewCount() {
        var pv = PagedView(pageSize: 10)
        pv.onListFetched(page: 1, total: 1, limit: 10)
        XCTAssertEqual(pv.currentDepth, 10)
        XCTAssertFalse(pv.hasMorePages())

    }

    func testPagedViewReset() {
        var pv = PagedView(pageSize: 10)
        pv.onListFetched(page: 1, total: 3, limit: 10)
        pv.onListFetched(page: 2, total: 3, limit: 10)
        pv.onListFetched(page: 3, total: 3, limit: 10)
        XCTAssertEqual(pv.currentPage, 3)
        XCTAssertEqual(pv.nextPage, 3)
        XCTAssertFalse(pv.hasMorePages())
        pv.resetToFirstPage()
        XCTAssertEqual(pv.currentPage, 1)
        XCTAssertEqual(pv.nextPage, 1)
        XCTAssertEqual(pv.currentDepth, 0)
        XCTAssertFalse(pv.hasMorePages())
        pv.onListFetched(page: 1, total: 3, limit: 10)
        XCTAssertEqual(pv.currentPage, 1)
        XCTAssertEqual(pv.nextPage, 2)
        XCTAssertEqual(pv.currentDepth, 10)
        XCTAssertTrue(pv.hasMorePages())
    }

    func testEnsureNoFakeScroll() {
        // Never should make it to the CI
        XCTAssertFalse(fakeInfiniteScroll)
    }
}
