//
//  RegistrationCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 02/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import FBSDKCoreKit
import Resolver
import WhoppahDataStore
import WhoppahRepository

enum RegistrationStep: Int, CaseIterable {
    case accountChooser = 0
    case email
    case password
    case merchantDetail
    case merchantContact
    case merchantAddress

    static func numSteps(type: GraphQL.MerchantType, isNewUser: Bool) -> Int {
        switch type {
        case .individual:
            return RegistrationStep.merchantDetail.rawValue
        case .business:
            guard isNewUser else {
                return RegistrationStep.merchantAddress.rawValue - RegistrationStep.password.rawValue
            }
            return RegistrationStep.merchantAddress.rawValue
        default:
            return 0
        }
    }

    static func stepValue(_ step: RegistrationStep, isNewUser: Bool) -> Int {
        isNewUser ? step.rawValue : step.rawValue - RegistrationStep.password.rawValue
    }

    func next(type: GraphQL.MerchantType) -> RegistrationStep? {
        guard rawValue + 1 < RegistrationStep.allCases.count else { return nil }
        if type == .individual, rawValue >= RegistrationStep.merchantDetail.rawValue { return nil }
        return RegistrationStep.allCases[rawValue + 1]
    }
}

protocol RegistrationCoordinator: Coordinator {
    init(navigationController: UINavigationController)

    func start(step: RegistrationStep, type: GraphQL.MerchantType?)

    func register(via network: SocialNetwork, completion: @escaping ((Bool) -> Void))

    func onProfileEdited(_ completion: @escaping (() -> Void))

    func requestNotificationPermission()

    func dismiss()
}

class RegistrationCoordinatorImpl: RegistrationCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var viewModel: RegistrationViewModel?
    
    @Injected private var pushNotificationService: PushNotificationsService
    @Injected private var userService: WhoppahCore.LegacyUserService

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(step: RegistrationStep, type: GraphQL.MerchantType?) {
        switch step {
        case .accountChooser:
            viewModel = RegistrationViewModel(coordinator: self)
            let vc = AccountTypeChooserViewController()
            vc.viewModel = viewModel
            navigationController.pushViewController(vc, animated: true)
        case .email:
            guard let vm = viewModel else { fatalError("Expected view model to be set") }
            let vc = SignUpViewController()
            vc.viewModel = vm
            navigationController.pushViewController(vc, animated: true)
        case .password:
            guard let vm = viewModel else { fatalError("Expected view model to be set") }
            let vc = SignUpPasswordViewController()
            vc.viewModel = vm
            navigationController.pushViewController(vc, animated: true)
        case .merchantDetail:
            if viewModel == nil {
                viewModel = RegistrationViewModel(coordinator: self, step: step)
            }

            if type == .individual {
                let vc = IndividualPhoneNumberViewController()
                vc.viewModel = viewModel
                navigationController.pushViewController(vc, animated: true)
            } else {
                let vc = BusinessInfoViewController()
                vc.viewModel = viewModel
                navigationController.pushViewController(vc, animated: true)
            }
        case .merchantContact:
            if viewModel == nil {
                viewModel = RegistrationViewModel(coordinator: self, step: step)
            }
            let vc = BusinessContactViewController()
            vc.viewModel = viewModel!
            navigationController.pushViewController(vc, animated: true)
        case .merchantAddress:
            if viewModel == nil {
                viewModel = RegistrationViewModel(coordinator: self, step: step)
            }
            let vc = BusinessAddresssViewController()
            vc.viewModel = viewModel!
            navigationController.pushViewController(vc, animated: true)
        }
    }

    func register(via network: SocialNetwork, completion: @escaping ((Bool) -> Void)) {
        guard let top = navigationController.topViewController else { return }
        
        if network == .facebook {
            AppEvents.shared.logEvent(AppEvents.Name(rawValue: "FBSDKAppEventNameStartedRegistration"))
        }
        
//        authService.authorize(via: network, withVC: top, mode: .register) { result in
//            DispatchQueue.main.async {
//                guard let result = result else {
//                    completion(true)
//                    return
//                }
//                switch result {
//                case .success:
//                    top.dismiss(animated: true) {
//                        completion(false)
//                    }
//                case let .failure(error):
//                    self.showError(error)
//                }
//            }
//        }
    }

    func dismiss() {
        guard let top = navigationController.topViewController else { return }
        top.dismiss(animated: true, completion: {
            self.navigationController.viewControllers.removeAll()
        })
    }

    func onProfileEdited(_ completed: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            guard let top = self.navigationController.topViewController else { return }
            top.dismiss(animated: true, completion: completed)
        }
    }

    func requestNotificationPermission() {
        guard let tabs = navigationController.getTabsVC() else { return }
        tabs.requestNotificationPermission(pushNotificationService: pushNotificationService,
                                           userService: userService) {
            Navigator().navigate(route: Navigator.Route.welcome)
        }
    }
}
