//
//  RegisterViewModelTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 09/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

@testable import Testing_Debug
@testable import WhoppahCore
import UIKit
import XCTest
import Resolver

var mockRegisterMember = MockMember(merchant: [MockMerchant(type: .business)])
let mockRegisterMerchant = mockRegisterMember.mainMerchant as! MockMerchant

class RegisterViewModelTests: XCTestCase {

    override func setUp() {
        MockServiceInjector.register()
        mockRegisterMerchant.add(theMember: mockRegisterMember)
        let userService: LegacyUserService = Resolver.resolve()
        if let mockUserService = userService as? MockUserService {
            mockUserService.current = mockRegisterMember
        }
    }

    override func tearDown() {
        let userService: LegacyUserService = Resolver.resolve()
        if let mockUserService = userService as? MockUserService {
            mockUserService.current = nil
        }
    }

    func testStepsSetAccountType() {
        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
        XCTAssertEqual(viewModel.currentStep, RegistrationStep.accountChooser.rawValue)
        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantDetail.rawValue)
    }

    func testStepsCreateAccountIndividual() throws {
//        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
//        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
//        viewModel.next() // Bypass the chooser
//
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.email)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.email.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantDetail.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.password)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.password.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantDetail.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantDetail)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.merchantDetail.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantDetail.rawValue)
//
//        let email = "test@email.com"
//        let password = "12345678"
//        viewModel.inputs.email.onNext(email)
//        viewModel.inputs.password.onNext(password)
//        viewModel.next()
//        let authService: AuthService = Resolver.resolve()
//        let auth = try XCTUnwrap(authService as? MockAuthService)
//
//        XCTAssertEqual(auth.signupEmail, email)
//        XCTAssertEqual(auth.signupPassword, password)
//        XCTAssertFalse(auth.signupIsMerchant!)
//        //XCTAssertTrue(mockCoordinator.emailConfirmationShown) // this step was removed from the app
//        XCTAssertTrue(mockCoordinator.notificationPermissionRequested)
//        XCTAssertFalse(mockCoordinator.profileEdited)
    }

    func testSignupViaFacebook() {
        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
        viewModel.merchantType = .individual
        viewModel.next() // Bypass the chooser
        viewModel.register(via: .facebook)

        XCTAssertEqual(mockCoordinator.registerWithNetwork, .facebook)

        XCTAssertFalse(mockCoordinator.emailConfirmationShown)
        XCTAssertTrue(mockCoordinator.notificationPermissionRequested)
        XCTAssertFalse(mockCoordinator.profileEdited)
    }

    func testSignupViaGoogle() {
        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
        viewModel.merchantType = .individual
        viewModel.next() // Bypass the chooser
        viewModel.register(via: .google)

        XCTAssertEqual(mockCoordinator.registerWithNetwork, .google)

        XCTAssertFalse(mockCoordinator.emailConfirmationShown)
        XCTAssertTrue(mockCoordinator.notificationPermissionRequested)
        XCTAssertFalse(mockCoordinator.profileEdited)
    }

    func testStepsCreateAccountMerchant() throws {
//        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
//        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
//        viewModel.merchantType = .business
//        viewModel.next() // Bypass the chooser
//
//        XCTAssertFalse(viewModel.allowSocial)
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.email)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.email.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantAddress.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.password)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.password.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantAddress.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantDetail)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.merchantDetail.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantAddress.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantContact)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.merchantContact.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantAddress.rawValue)
//
//        viewModel.next()
//        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantAddress)
//        XCTAssertEqual(viewModel.currentStep, RegistrationStep.merchantAddress.rawValue)
//        XCTAssertEqual(viewModel.numberOfSteps, RegistrationStep.merchantAddress.rawValue)
//
//        let email = "test@email.com"
//        let password = "12345678"
//        viewModel.inputs.email.onNext(email)
//        viewModel.inputs.password.onNext(password)
//        viewModel.next()
//        let authService: AuthService = Resolver.resolve()
//        let auth = try XCTUnwrap(authService as? MockAuthService)
//        XCTAssertEqual(auth.signupEmail, email)
//        XCTAssertEqual(auth.signupPassword, password)
//        XCTAssertTrue(auth.signupIsMerchant!)
//        //XCTAssertTrue(mockCoordinator.emailConfirmationShown) // this step was removed from the app
//        XCTAssertTrue(mockCoordinator.notificationPermissionRequested)
//        XCTAssertFalse(mockCoordinator.profileEdited)
    }

    func testSetAccountDataMerchantNewAddress() throws {
//        let userService: LegacyUserService = Resolver.resolve()
//        let mockUserService = try XCTUnwrap(userService as? MockUserService)
//        mockUserService.current = nil
//
//        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
//        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
//        viewModel.merchantType = .business
//        viewModel.next() // Bypass the chooser
//
//        let profile = "Test profile"
//        viewModel.inputs.profileName.onNext(profile)
//        let businessName = "My Co"
//        viewModel.inputs.companyName.onNext(businessName)
//        let phone = "+31101234567"
//        viewModel.inputs.phone.onNext(phone)
//        let first = "Eddie"
//        viewModel.inputs.firstName.onNext(first)
//        let last = "Long"
//        viewModel.inputs.lastName.onNext(last)
//        let line1 = "Vasumweg 56"
//        viewModel.inputs.line1.onNext(line1)
//        let city = "Amsterdam"
//        viewModel.inputs.city.onNext(city)
//        let postcode = "1033 SC"
//        viewModel.inputs.postcode.onNext(postcode)
//        let country = Country.netherlands
//        viewModel.inputs.country.onNext(country)
//
//        viewModel.next()
//        viewModel.next()
//        viewModel.next()
//        viewModel.next()
//
//        let mockRegisterMember = MockMember(merchant: [MockMerchant(type: .business)])
//        let mockRegisterMerchant = mockRegisterMember.mainMerchant as! MockMerchant
//        mockRegisterMerchant.address = []
//
//        mockUserService.current = mockRegisterMember
//
//        viewModel.next()
//
//        let merchantService: MerchantService = Resolver.resolve()
//        let merchant = try XCTUnwrap(merchantService as? MockMerchantService)
//
//        let input = try XCTUnwrap(merchant.merchantInput)
//        XCTAssertEqual(input.name, profile)
//        XCTAssertEqual(input.businessName, businessName)
//        XCTAssertEqual(input.phone, phone)
//
//        XCTAssertNotNil(merchant.addAddressInput)
//        let address = merchant.addAddressInput
//        XCTAssertEqual(address?.line1, line1)
//        XCTAssertEqual(address?.postalCode, postcode)
//        XCTAssertEqual(address?.city, city)
//        XCTAssertEqual(address?.country, country.rawValue)
//
//        let memberService: LegacyUserService = Resolver.resolve()
//        let member = try XCTUnwrap(memberService as? MockUserService)
//        XCTAssertNotNil(member.memberInput)
//        let memberInput = member.memberInput!
//
//        XCTAssertEqual(memberInput.givenName, first)
//        XCTAssertEqual(memberInput.familyName, last)
    }

    func testSetAccountDataMerchantUpdateAddress() throws {
//        let userService: LegacyUserService = Resolver.resolve()
//        let mockUserService = try XCTUnwrap(userService as? MockUserService)
//        mockUserService.current = nil
//
//        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
//        let viewModel = RegistrationViewModel(coordinator: mockCoordinator)
//        viewModel.merchantType = .business
//        viewModel.next() // Bypass the chooser
//
//        let profile = "Test profile"
//        viewModel.inputs.profileName.onNext(profile)
//        let businessName = "My Co"
//        viewModel.inputs.companyName.onNext(businessName)
//        let phone = "+31101234567"
//        viewModel.inputs.phone.onNext(phone)
//        let first = "Eddie"
//        viewModel.inputs.firstName.onNext(first)
//        let last = "Long"
//        viewModel.inputs.lastName.onNext(last)
//        let line1 = "Vasumweg 56"
//        viewModel.inputs.line1.onNext(line1)
//        let city = "Amsterdam"
//        viewModel.inputs.city.onNext(city)
//        let postcode = "1033 SC"
//        viewModel.inputs.postcode.onNext(postcode)
//        let country = Country.netherlands
//        viewModel.inputs.country.onNext(country)
//
//        viewModel.next()
//        viewModel.next()
//        viewModel.next()
//        viewModel.next()
//
//        let mockRegisterMember = MockMember(merchant: [MockMerchant(type: .business)])
//        let mockRegisterMerchant = mockRegisterMember.mainMerchant as! MockMerchant
//        mockRegisterMerchant.add(theMember: mockRegisterMember)
//
//        mockUserService.current = mockRegisterMember
//
//        viewModel.next()
//
//        let merchantService: MerchantService = Resolver.resolve()
//        let merchant = try XCTUnwrap(merchantService as? MockMerchantService)
//        let input = try XCTUnwrap(merchant.merchantInput)
//        XCTAssertEqual(input.name, profile)
//        XCTAssertEqual(input.businessName, businessName)
//        XCTAssertEqual(input.phone, phone)
//
//        XCTAssertNotNil(merchant.updateAddressInput)
//        let address = merchant.updateAddressInput
//        XCTAssertEqual(address?.line1, line1)
//        XCTAssertEqual(address?.postalCode, postcode)
//        XCTAssertEqual(address?.city, city)
//        XCTAssertEqual(address?.country, country.rawValue)
//
//        let memberService: LegacyUserService = Resolver.resolve()
//        let member = try XCTUnwrap(memberService as? MockUserService)
//        XCTAssertNotNil(member.memberInput)
//        let memberInput = member.memberInput!
//
//        XCTAssertEqual(memberInput.givenName, first)
//        XCTAssertEqual(memberInput.familyName, last)
    }

    func testStepsEditAccountMerchant() {
        let userService: LegacyUserService = Resolver.resolve()
        if let mockUserService = userService as? MockUserService {
            mockUserService.current = mockRegisterMember
        }

        let mockCoordinator = MockRegistrationCoordinator(navigationController: UINavigationController())
        let viewModel = RegistrationViewModel(coordinator: mockCoordinator, step: .merchantDetail)

        //XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantDetail)
        XCTAssertEqual(viewModel.currentStep, 1)
        XCTAssertEqual(viewModel.numberOfSteps, 3)

        viewModel.next()
        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantContact)
        XCTAssertEqual(viewModel.currentStep, 2)
        XCTAssertEqual(viewModel.numberOfSteps, 3)

        viewModel.next()
        XCTAssertEqual(mockCoordinator.stepExecuted, RegistrationStep.merchantAddress)
        XCTAssertEqual(viewModel.currentStep, 3)
        XCTAssertEqual(viewModel.numberOfSteps, 3)

        viewModel.next()
        Thread.sleep(forTimeInterval: 0.5)

        XCTAssertFalse(mockCoordinator.emailConfirmationShown)
        XCTAssertTrue(mockCoordinator.notificationPermissionRequested)
        XCTAssertTrue(mockCoordinator.profileEdited)
    }
}
