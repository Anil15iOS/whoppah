//
//  PriceTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 16/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import XCTest

class PriceTests: XCTestCase {
    lazy var testUserWithCompany = """
    {
    "id": 27,
    "username": "test",
    "email": "thomas+12@whoppah.com",
    "date_joined": "2019-04-18T14:19:08.176709+02:00",
    "last_login": "2019-05-16T10:25:49.577180+02:00",
    "first_name": "Thomas",
    "last_name": "Bunnik",
    "profile": {
    "id": 53,
    "phone": "+31612430320",
    "gender": null,
    "birthday": null,
    "avatar": null,
    "about": null,
    "favorite_styles": [],
    "favorite_colors": [],
    "verified": false,
    "favorite_materials": [],
    "favorite_brands": [],
    "background": null
    },
    "locations": [],
    "is_merchant": true,
    "company": {
    "id": 13,
    "name": "Test Company",
    "kvk": "60654694",
    "phone": "+31612430320",
    "about": "test",
    "brands": [],
    "logo": null,
    "antiques": true,
    "handmade": true,
    "returned": false,
    "showroom": false,
    "locations": [{
    "name": null,
    "id": 34,
    "street": "Noorddammerweg",
    "building": null,
    "city": "Amstelveen",
    "country": "Países Bajos",
    "zipcode": "1187 ZS",
    "default": true,
    "point": {
    "type": "Point",
    "coordinates": [4.8193363, 52.2725739]
    }
    }],
    "second_hand": true,
    "refurbished": true,
    "design": true,
    "fee_percent": 15
    }
    }
    """

    lazy var testUserWithoutCompany = """
    {
    "id": 27,
    "username": "test",
    "email": "thomas+12@whoppah.com",
    "date_joined": "2019-04-18T14:19:08.176709+02:00",
    "last_login": "2019-05-16T10:25:49.577180+02:00",
    "first_name": "Thomas",
    "last_name": "Bunnik",
    "profile": {
        "id": 53,
        "phone": "+31612430320",
        "gender": null,
        "birthday": null,
        "avatar": null,
        "about": null,
        "favorite_styles": [],
        "favorite_colors": [],
        "verified": false,
        "favorite_materials": [],
        "favorite_brands": [],
        "background": null
    },
    "locations": [],
    "is_merchant": false,
    "company": null
    }
    """

    func testPriceAndFeeBreakdownUserNoCompany() {
        let price = 100.0
        guard let user = try? JSONDecoder().decode(User.self, from: testUserWithoutCompany.data(using: .utf8)!) else {
            return XCTFail("Unable to decode user")
        }
        let breakdown = getPriceBreakdown(user: user, price: price)
        XCTAssertEqual(breakdown.price, price, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahPercentage, 0, accuracy: Double.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahFee, 0.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.vat, 0.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.vatRate, 21.0, accuracy: Double.ulpOfOne)
        XCTAssertEqual(breakdown.total, breakdown.price, accuracy: Money.ulpOfOne)
    }

    func testPriceAndFeeBreakdownUserCompany() {
        let price = 100.0
        guard let user = try? JSONDecoder().decode(User.self, from: testUserWithCompany.data(using: .utf8)!) else {
            return XCTFail("Unable to decode user")
        }
        let breakdown = getPriceBreakdown(user: user, price: price)
        XCTAssertEqual(breakdown.price, price, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahPercentage, user.company!.whoppahFeePercent, accuracy: Double.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahFee, price * Double(breakdown.whoppahPercentage) / 100.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.vatRate, 21.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.vat, breakdown.whoppahFee * Double(user.company!.vatRate) / 100.0)
        XCTAssertEqual(breakdown.total, breakdown.price - breakdown.whoppahFee - breakdown.vat, accuracy: Money.ulpOfOne)
    }

    func testNilPrice() {
        let price: Money? = nil
        guard let user = try? JSONDecoder().decode(User.self, from: testUserWithCompany.data(using: .utf8)!) {
            return XCTFail("Unable to decode user")
        }
        let breakdown = getPriceBreakdown(user: user, price: price)
        XCTAssertEqual(breakdown.price, 0.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahFee, 0.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.whoppahPercentage, user.company!.whoppahFeePercent, accuracy: Double.ulpOfOne)
        XCTAssertEqual(breakdown.vat, 0.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.vatRate, 21.0, accuracy: Money.ulpOfOne)
        XCTAssertEqual(breakdown.total, 0.0, accuracy: Money.ulpOfOne)
    }
}
