//
//  MockRegistrationCoordinator.swift
//  WhoppahTests
//
//  Created by Eddie Long on 09/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
@testable import Testing_Debug
@testable import WhoppahCore
@testable import WhoppahDataStore

class MockRegistrationCoordinator: RegistrationCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController = UINavigationController()

    var profileEdited = false
    var emailConfirmationShown = false
    var notificationPermissionRequested = false
    var registerWithNetwork: SocialNetwork?
    var stepExecuted: RegistrationStep?
    var typeExecuted:  GraphQL.MerchantType?

    required init(navigationController: UINavigationController) {}

    func start(step: RegistrationStep, type: GraphQL.MerchantType?) {
        stepExecuted = step
        typeExecuted = type
    }

    func register(via network: SocialNetwork, completion: @escaping ((Bool) -> Void)) {
        registerWithNetwork = network
        completion(false)
    }

    func onProfileEdited(_ completion: @escaping (() -> Void)) {
        profileEdited = true
        completion()
    }

    func dismiss() { }

    func openEmailConfirmationScreen(_ completion: @escaping (() -> Void)) {
        emailConfirmationShown = true
        completion()
    }

    func requestNotificationPermission() {
        notificationPermissionRequested = true
    }
}
