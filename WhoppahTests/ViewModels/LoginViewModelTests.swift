//
//  LoginViewModelTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 10/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
@testable import Testing_Debug
@testable import WhoppahCore
import UIKit
import XCTest
import Resolver

var mockLoginMember = MockMember(merchant: [MockMerchant(type: .business)])
let mockLoginMerchant = mockRegisterMember.mainMerchant as! MockMerchant

class LoginViewModelTests: XCTestCase {

    override func setUp() {
        MockServiceInjector.register()
        mockLoginMerchant.add(theMember: mockRegisterMember)
        
        let userService: LegacyUserService = Resolver.resolve()
        (userService as? MockUserService)?.current = mockLoginMember
    }

    override func tearDown() {
        let userService: LegacyUserService = Resolver.resolve()
        (userService as? MockUserService)?.current = nil
    }

    func testSocialLoginFacebook() {
//        let loginCoordinator = MockLoginCoordinator(navigationController: UINavigationController())
//        let viewModel = LoginViewModel(coordinator: loginCoordinator)
//        viewModel.login(withNetwork: .facebook)
//        XCTAssertEqual(loginCoordinator.socialNetworkLogin, .facebook)
//        XCTAssertTrue(loginCoordinator.dismissed)
//        XCTAssertTrue(loginCoordinator.notificationPermissionRequested)
    }

    func testSocialLoginGoogle() {
//        let loginCoordinator = MockLoginCoordinator(navigationController: UINavigationController())
//        let viewModel = LoginViewModel(coordinator: loginCoordinator)
//        viewModel.login(withNetwork: .google)
//        XCTAssertEqual(loginCoordinator.socialNetworkLogin, .google)
//        XCTAssertTrue(loginCoordinator.dismissed)
//        XCTAssertTrue(loginCoordinator.notificationPermissionRequested)
    }

    func testLogin() throws {
//        let loginCoordinator = MockLoginCoordinator(navigationController: UINavigationController())
//        let viewModel = LoginViewModel(coordinator: loginCoordinator)
//        let email = "testing@whoppah.com"
//        let password = "password"
//        viewModel.login(withEmail: email, andPassword: password)
//        XCTAssertNil(loginCoordinator.socialNetworkLogin)
//        let authService: AuthService = Resolver.resolve()
//        let auth = try XCTUnwrap(authService as? MockAuthService)
//        XCTAssertEqual(auth.loginEmail, email)
//        XCTAssertEqual(auth.loginPassword, password)
//        XCTAssertTrue(loginCoordinator.dismissed)
//        XCTAssertTrue(loginCoordinator.notificationPermissionRequested)
    }
}
