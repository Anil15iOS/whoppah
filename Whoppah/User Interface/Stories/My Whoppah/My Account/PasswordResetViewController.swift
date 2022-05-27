//
//  PasswordResetViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 19/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCoreNext
import Resolver
import WhoppahCore

class PasswordResetViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var loginButton: PrimaryLargeButton!

    // MARK: - Properties

    typealias LoginRequested = () -> Void
    var onLoginRequested: LoginRequested?
    
    @Injected private var userService: WhoppahCore.LegacyUserService

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }

    // MARK: - Private

    private func setUpButtons() {
        loginButton.style = .primary
        let hasExistingToken = userService.isLoggedIn
        loginButton.isVisible = onLoginRequested != nil && !hasExistingToken
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        if navigationController == nil || navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func loginButton(_: UIButton) {
        if navigationController == nil || navigationController?.viewControllers.count == 1 {
            dismiss(animated: true) {
                self.onLoginRequested?()
            }
        } else {
            navigationController?.popViewController(animated: true) {
                self.onLoginRequested?()
            }
        }
    }
}
