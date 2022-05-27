//
//  UserTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 16/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

class UserTests: XCTestCase {
    func testValidUsername() {
        XCTAssertTrue(Member.isValidUsername("12345678"))
        XCTAssertTrue(Member.isValidUsername("1234abcd"))
        XCTAssertTrue(Member.isValidUsername("1234_abcd"))
        XCTAssertTrue(Member.isValidUsername("ABCDEFGH"))
        XCTAssertTrue(Member.isValidUsername("123_AB_cd"))
        XCTAssertTrue(Member.isValidUsername("____"))
        XCTAssertTrue(Member.isValidUsername("1")) // min length
        XCTAssertTrue(Member.isValidUsername("12345678901234567890")) // max length
    }

    func testInvalidUsernameSpecialCharacters() {
        // Not going to test all variants of special characters :)
        XCTAssertFalse(Member.isValidUsername("abcdef%"))
        XCTAssertFalse(Member.isValidUsername("abcdef$"))
        XCTAssertFalse(Member.isValidUsername("abc def"))
        XCTAssertFalse(Member.isValidUsername("abc+def"))
        XCTAssertFalse(Member.isValidUsername("abc/def"))
        XCTAssertFalse(Member.isValidUsername("abc\\def"))
        XCTAssertFalse(Member.isValidUsername("abc-def"))
        XCTAssertFalse(Member.isValidUsername("abc#def"))
        XCTAssertFalse(Member.isValidUsername("abc$def"))
        XCTAssertFalse(Member.isValidUsername("abc^def"))
        XCTAssertFalse(Member.isValidUsername("abc*def"))
        XCTAssertFalse(Member.isValidUsername("abc:def"))
        XCTAssertFalse(Member.isValidUsername("abc\"def"))
        XCTAssertFalse(Member.isValidUsername("abc'def"))
        XCTAssertFalse(Member.isValidUsername("abc€def"))
        XCTAssertFalse(Member.isValidUsername("abc()def"))
        XCTAssertFalse(Member.isValidUsername("abc?def"))
        XCTAssertFalse(Member.isValidUsername("abc=def"))
        XCTAssertFalse(Member.isValidUsername("abc!def"))
        XCTAssertFalse(Member.isValidUsername("abc~def"))
        XCTAssertFalse(Member.isValidUsername("123456789012345678901")) // > max length
    }

    func testValidPassword() {
        XCTAssertTrue(Member.validatePassword("Whoppah1").isValid)
        // Password to short
        XCTAssertTrue(Member.validatePassword("Whoppah1").isValid)
    }

    func testPasswordTooShort() {
        let result = Member.validatePassword("Whopp2h")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.validLength)
    }

    func testPasswordMissingCapital() {
        let result = Member.validatePassword("whoppah1")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.hasCapitalLetter)
    }

    func testPasswordMissingNumber() {
        let result = Member.validatePassword("Whoppahh")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.hasNumber)
    }

    func testPasswordMissingLowercase() {
        let result = Member.validatePassword("WHOPPAH1")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.hasLowerLetter)
    }

    func testPasswordMissingLowercaseAndNumber() {
        let result = Member.validatePassword("WHOPPAHH")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.hasLowerLetter)
        XCTAssertFalse(result.hasNumber)
    }

    func testPasswordMissingCapitalAndLower() {
        let result = Member.validatePassword("12345678")
        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.hasLowerLetter)
        XCTAssertFalse(result.hasCapitalLetter)
    }
}
