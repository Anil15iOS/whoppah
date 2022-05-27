//
//  DeeplinkParserTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 08/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

@testable import WhoppahCore
@testable import Testing_Debug
@testable import WhoppahDataStore

class DeeplinkParserTests: XCTestCase {
    func testInvalidDeeplink() {
        let url = URL(string: "whoppah://somejunk")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .unknown = result else {
            XCTFail()
            return
        }
    }

    func testInvalidDeeplinkDomain() {
        // This is valid - don't validate the scheme
        let url = URL(string: "floppah://address?user=123&key=efgh")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .unknown = result else {
            XCTFail()
            return
        }
    }

    func testAddressDeeplink() {
        let uuid = UUID()
        let url = URL(string: "whoppah://address?user=\(uuid.uuidString)&key=efgh")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .finaliseAccount(let userID, let token) = result else {
             XCTFail()
            return
        }
        XCTAssertEqual(userID.uuidString, uuid.uuidString)
        XCTAssertEqual(token, "efgh")
    }

    func testWelcomeDeeplink() {
        let uuid = UUID()
        let url = URL(string: "whoppah://welcome?user=\(uuid.uuidString)&key=efgh")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .finaliseAccount(let userID, let token) = result else {
             XCTFail()
            return
        }
        XCTAssertEqual(userID.uuidString, uuid.uuidString)
        XCTAssertEqual(token, "efgh")
    }

    func testInvalidAddressDeeplink() {
        let url = URL(string: "whoppah://address?user_a=123&key=efgh")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .unknown = result else {
            XCTFail()
            return
        }
    }

    func testResetPasswordDeeplink() {
        let url = URL(string: "whoppah://reset-password?uid=abcd&token=efgh")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .resetPassword(let userID, let token) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(userID, "abcd")
        XCTAssertEqual(token, "efgh")
    }

    func testUSPDeeplink() {
        let url = URL(string: "whoppah://usp")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .usp = result else {
            XCTFail()
            return
        }
    }

    func testLooksDeeplink() {
        let url = URL(string: "whoppah://looks")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .looks = result else {
            XCTFail()
            return
        }
    }

    func testMapDeeplink() {
        let url = URL(string: "whoppah://map")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .map = result else {
            XCTFail()
            return
        }
    }

    func testSearchDeepLinkEmpty() {
        let url = URL(string: "whoppah://search")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .search(let data) = result else {
            XCTFail()
            return
        }
        XCTAssertNil(data.query)
        XCTAssertNil(data.filters?.isEmpty)
        XCTAssertNil(data.sort)
        XCTAssertNil(data.order)
    }

    func testAdDeeplink() {
        let uuid = UUID()
        let url = URL(string: "whoppah://ad?id=\(uuid.uuidString)")!
        let parser = DeeplinkParser()
        let result = parser.parseDeepLink(url)
        guard case .adDetails(let data) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(data.id.uuidString, uuid.uuidString)
    }

}
