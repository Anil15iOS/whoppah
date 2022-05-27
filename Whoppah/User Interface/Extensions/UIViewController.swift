//
//  UIViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/20/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import RxSwift
import UIKit
import WhoppahCore

extension UIViewController {
    func setNavBar(title: String? = nil, enabled: Bool = true, transparent: Bool? = nil) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.isNavigationBarHidden = !enabled
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        self.title = title
    }

    enum CloseButtonOrientation {
        case left
        case right
    }
    func addCloseButton(image: UIImage?, orientation: CloseButtonOrientation = .left) -> UIBarButtonItem {
        let back = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        switch orientation {
        case .left:
            navigationItem.leftBarButtonItem = back
        case .right:
            navigationItem.rightBarButtonItem = back
        }
        return back
    }

    func addCustomCloseButton() -> UIBarButtonItem {
        navigationItem.hidesBackButton = true
        let newBack = UIBarButtonItem(image: R.image.backButtonIcon(), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = newBack
        return newBack
    }
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: R.string.localizable.merchant_profile_incomplete_dialog_ok_button(), style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    enum SafeInsetType {
        case top
        case bottom
    }

    func getTabsVC() -> TabsViewController? {
        guard let navigationVC = UIApplication.shared.window?.rootViewController as? UINavigationController else { return nil }
        guard let tabsVC = navigationVC.viewControllers.first as? TabsViewController else { return nil }
        return tabsVC
    }

    func removeFromParentVC() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

// MARK: Error handling

extension UIViewController {
    func showError(_ error: Error) {
        guard (error as NSError?)?.code != NSURLErrorCancelled else { return }
        let localizedDescription = error.localizedDescription
        let message = localizedDescription.count > 512 ? "\(localizedDescription.prefix(512))..." : localizedDescription
        showErrorDialog(message: message)
    }

    // MARK: - Dialogs

    @objc func showErrorDialog(title: String = "Whoops!", message: String = R.string.localizable.common_generic_error_message()) {
        let dialogVC = MessageDialog(title: title, message: message)
        present(dialogVC, animated: true, completion: nil)
    }
}

// MARK: -

extension UIViewController {
    func showSettingsApp(completion: ((Bool) -> Void)?) {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            completion?(false)
        }
    }
}

extension UIViewController {
    func requestNotificationPermission(pushNotificationService: PushNotificationsService,
                                       userService: LegacyUserService,
                                       completion: @escaping (() -> Void)) {
        guard userService.current != nil else { return completion() }
        pushNotificationService.checkNotificationPermission { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    let message = R.string.localizable.main_permission_dialog_message()
                    let dialog = YesNoDialog.create(withMessage: message, andTitle: "") { result in
                        if result == .yes {
                            pushNotificationService.requestNotificationPermission { _ in
                                DispatchQueue.main.async {
                                    completion()
                                }
                            }
                        } else {
                            completion()
                        }
                    }
                    // This goes on top of everything
                    dialog.definesPresentationContext = true
                    self.topViewController().present(dialog, animated: true, completion: nil)
                case .authorized:
                    // This won't do anything - but will ensure we register correctly with the backend
                    pushNotificationService.requestNotificationPermission { _ in
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                default:
                    break
                }
            }
        }
    }

    private func topViewController() -> UIViewController {
        var vc = self

        while let presented = vc.presentedViewController, vc != presented {
            vc = presented
        }
        return vc
    }
}
