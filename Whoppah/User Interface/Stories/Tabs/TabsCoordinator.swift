//
//  TabsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 05/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import Resolver
import UIKit
import WhoppahDataStore
import WhoppahUI
import WhoppahModel

class TabsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openThread(threadID: UUID, route: Navigator.Route? = nil) {
        let coordinator = ThreadCoordinator(navigationController: navigationController)
        coordinator.start(threadID: threadID, route: route)
    }

    func openAdDetails(id: UUID) {
        let coordinator = AdDetailsCoordinator(navigationController: navigationController)
        coordinator.start(adID: id)
    }

    func openWelcome() {
        guard let top = navigationController.topViewController else { return }
        let welcome = WelcomeDialogHostingController(presentingViewController: top, isNewUser: true)
        welcome.isModalInPresentation = true
        welcome.modalPresentationStyle = .overFullScreen
        welcome.view.backgroundColor = .clear
        top.present(welcome, animated: true, completion: nil)
    }

    func openPublicProfile(id: UUID) {
        let coordinator = PublicProfileCoordinator(navigationController: navigationController)
        coordinator.start(id: id)
    }

    func openSearch(input: SearchProductsInput) {
        let coordinator = SearchResultsCoordinator(navigationController: navigationController)
        coordinator.start(input: input)
    }

    func openCameraSearch() {
        guard let top = navigationController.topViewController else { return }
        let cameraSearchVC: CameraSearchViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        cameraSearchVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { cameraSearchVC.modalPresentationStyle = .fullScreen }
        top.present(cameraSearchVC, animated: true, completion: nil)
    }

    func openMerchantCompletion() {
        let navVC = WhoppahNavigationController()
        navVC.isNavigationBarHidden = true
        navVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navVC.modalPresentationStyle = .fullScreen }
        let coordinator = RegistrationCoordinatorImpl(navigationController: navVC)
        coordinator.start(step: .merchantDetail, type: .business)
        present(vc: navVC)
    }

    func openUSP() {
        let coordinator = AssuranceCoordinator(navigationController: navigationController)
        coordinator.start()
    }

    func openAccountCreatedDialog(forType type: AccountCreatedDialog.AccountType) {
        let accountCreated = AccountCreatedDialog.create(forType: type)
        present(vc: accountCreated)
    }

    func openContact() {
        let vc = ContactViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openCreateAd() {
        guard let top = navigationController.topViewController else { return }
        let addingAnAdNavigation = WhoppahNavigationController()
        addingAnAdNavigation.isNavigationBarHidden = true
        addingAnAdNavigation.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { addingAnAdNavigation.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdOnboardingCoordinatorImpl(navigationController: addingAnAdNavigation)
        coordinator.start()
        top.present(addingAnAdNavigation, animated: true, completion: nil)
    }

    func openMap(latitude: Double?, longitude: Double?) {
        let coordinator = MapSearchCoordinator(navigationController: navigationController)
        coordinator.start(latitude: latitude, longitude: longitude, clearFiltersOnExit: true)
    }

    func openLooks() {
        let coordinator = LooksCoordinator(navigationController: navigationController)
        let pageRepo = PageRepositoryImpl()
        let repo = LooksRepositoryImpl(pageRepo: pageRepo)
        coordinator.start(repository: repo)
    }

    func openResetPassword(userID: String, token: String) {
//        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }
//        let resetPasswordVC: ResetPasswordViewController = UIStoryboard(storyboard: .auth).instantiateViewController()
//        resetPasswordVC.userID = userID
//        resetPasswordVC.token = token
//        let nav = WhoppahNavigationController(rootViewController: resetPasswordVC)
//        nav.isNavigationBarHidden = true
//        if #available(iOS 13.0, *) { nav.isModalInPresentation = true }
//        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
//        if let presented = root.presentedViewController {
//            presented.present(nav, animated: true, completion: nil)
//        } else {
//            root.present(nav, animated: true, completion: nil)
//        }
    }
    
    func openForgotPassword(initialView: LoginView.NavigationView) {
        guard let topViewController = navigationController.topViewController else { return }
        
        let hostingController = LoginViewHostingController(initialView: initialView,
                                                           presentingViewController: topViewController)
        hostingController.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { hostingController.modalPresentationStyle = .fullScreen }
        topViewController.present(hostingController, animated: true, completion: nil)
    }

    func openContextualSignup(title: String, description: String) {
        guard let topViewController = navigationController.topViewController else { return }
        
        let signupDialog = ContextualSignupDialogHostingController(presentingViewController: topViewController,
                                                                   title: title,
                                                                   description: description)
        signupDialog.isModalInPresentation = true
        signupDialog.modalPresentationStyle = .overFullScreen
        signupDialog.view.backgroundColor = .clear
        
        topViewController.present(signupDialog, animated: true, completion: nil)
    }

    func openSignupSplash() {
        guard let presentingViewController = self.presentingViewController,
              navigationController.visibleViewController as? SignupSplashViewHostingController == nil
        else { return }

        let signUpSplashVC = SignupSplashViewHostingController(presentingViewController: presentingViewController)
        let navigationVC = WhoppahNavigationController(rootViewController: signUpSplashVC)
        navigationVC.isNavigationBarHidden = true
        navigationVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navigationVC.modalPresentationStyle = .fullScreen }

        present(vc: navigationVC)
    }

    func openDocument(url: URL) {
        let documentVC: DocumentViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        documentVC.titleText = "Whoppah"
        documentVC.dateText = nil
        documentVC.mode = .url(name: url)
        navigationController.pushViewController(documentVC, animated: true)
    }
    
    var presentingViewController: UIViewController? {
        return navigationController.presentedViewController ?? navigationController.topViewController
    }

    private func present(vc: UIViewController) {
        presentingViewController?.present(vc, animated: true, completion: nil)
    }
}
