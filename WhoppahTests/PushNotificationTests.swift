//
//  PushNotificationTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 08/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

import XCTest

@testable import Testing_Debug
@testable import WhoppahCore

class PushNotificationTests: XCTestCase {
    func testProfileUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("whoppah://profile?id=\(uuid.uuidString)")
        switch route {
        case .userProfile(let data):
            XCTAssertEqual(data.uuidString, uuid.uuidString)
        default:
            XCTFail()
        }
    }

    func testChatUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("whoppah://chat?id=\(uuid.uuidString)")
        switch route {
        case .chat(let data):
            XCTAssertEqual(data.uuidString, uuid.uuidString)
        default:
            XCTFail()
        }
    }

    func testCreateAdUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://create-ad")
        switch route {
        case .createAd:
            print("success")
        default:
            XCTFail()
        }
    }

    func testMyWhoppahAccountsUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://my-whoppah/account")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .none = section {
                    print("All good")
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMyWhoppahAccountsSettingsUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://my-whoppah/account-settings")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .settings = section {
                    print("All good")
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMyWhoppahPaymenttUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://my-whoppah/payment")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .payment = section {
                    print("All good")
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMyWhoppahContactUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://my-whoppah/contact")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .contact = section {
                    print("All good")
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMySearchSettingsUrl() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("whoppah://my-whoppah/saved-search")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .search(let id) = section {
                    XCTAssertNil(id)
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMySearchSettingsWithIdUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("whoppah://my-whoppah/saved-search?id=\(uuid.uuidString)")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .search(let id) = section {
                    XCTAssertNotNil(id)
                    XCTAssertEqual(id!.uuidString, uuid.uuidString)
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }

    func testMyWhoppahAdUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("whoppah://my-whoppah/ad?id=\(uuid.uuidString)")
        switch route {
        case .myWhoppah(let data):
            if case .myAds(let section) = data.tab {
                switch section {
                case .ad(id: let id):
                    XCTAssertEqual(id.uuidString, uuid.uuidString)
                default: XCTFail("Expected match on ad section")
                }
            } else {
                XCTFail("Expected to match my ads")
            }
        default:
            XCTFail()
        }
    }

    func testAdDetailsUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("whoppah://ad?id=\(uuid.uuidString)")
        switch route {
        case .adDetails(let data):
            XCTAssertEqual(data.id.uuidString, uuid.uuidString)
        default:
            XCTFail()
        }
    }

    func testFullURLAdDetailsUrl() {
        let parser = PushNotificationsParser()
        let uuid = UUID()
        let route = parser.parseUrl("https://share.whoppah.com/ad?id=\(uuid.uuidString)")
        switch route {
        case .adDetails(let data):
            XCTAssertEqual(data.id.uuidString, uuid.uuidString)
        default:
            XCTFail()
        }
    }

    func testFullURLMyWhoppahContact() {
        let parser = PushNotificationsParser()
        let route = parser.parseUrl("https://share.whoppah.com/my-whoppah/contact")
        switch route {
        case .myWhoppah(let data):
            if case .account(let section) = data.tab {
                if case .contact = section {
                    print("All good")
                } else {
                    XCTFail("Expected settings")
                }
            } else {
                XCTFail("Expected to match account")
            }
        default:
            XCTFail()
        }
    }
}
