//
//  RequestReviewDisplayTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

@testable import Testing_Debug

class RequetReviewDisplayTests: XCTestCase {

    private let testingKey = "my_key"
    override func setUp() {
        RequestReviewDialog.reset(testingKey)
    }

    override func tearDown() {
        RequestReviewDialog.reset(testingKey)
    }

    func testNoReviewPreviouslyShown() {
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey))
    }

    func testSingleReviewDefaultDuration() {

        // Test default duration
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey))
        // Test setting interval to 1 day
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        RequestReviewDialog.onReviewShown(testingKey)
        // Verify that we now can't show the dialog
        XCTAssertFalse(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        RequestReviewDialog.reset(testingKey)
    }

    func testReviewSecondsComponent() {
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        RequestReviewDialog.onReviewShown(testingKey)

        // Fail as only waiting for <2 seconds and require >= 2 seconds
        let reviewExp1 = expectation(description: "Wait For Review 1")
        _ = XCTWaiter.wait(for: [reviewExp1], timeout: 0.5)
        XCTAssertFalse(RequestReviewDialog.canShowReview(testingKey, targetInterval: 2, component: Calendar.Component.second))

        // Success - >= 2 wait time
        let reviewExp2 = expectation(description: "Wait For Review 2")
        _ = XCTWaiter.wait(for: [reviewExp2], timeout: 2.0)
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey, targetInterval: 2, component: Calendar.Component.second))

        RequestReviewDialog.reset(testingKey)
    }

    func testReset() {
        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        RequestReviewDialog.onReviewShown(testingKey)
        XCTAssertFalse(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        // Reset means we can show again until 'onReviewShown' is called
        RequestReviewDialog.reset(testingKey)

        XCTAssertTrue(RequestReviewDialog.canShowReview(testingKey, targetInterval: 1))
        RequestReviewDialog.reset(testingKey)
    }
}
