//
//  AccountCreatedDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 23/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class AccountCreatedDialog: BaseDialog {
    // MARK: Outlets

    @IBOutlet var personLabel: UILabel!
    @IBOutlet var merchantLabel: UILabel!
    @IBOutlet var button: PrimaryLargeButton!
    
    @Injected private var userService: WhoppahCore.LegacyUserService

    enum AccountType {
        case person
        case merchant
    }

    private var accountType = AccountType.person

    static func create(forType type: AccountType) -> AccountCreatedDialog {
        let dialog = AccountCreatedDialog()
        dialog.accountType = type
        return dialog
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLabels()
        setUpButtons()
    }

    // MARK: Private

    private func setUpLabels() {
        personLabel.isVisible = (accountType == .person)
        merchantLabel.isVisible = (accountType == .merchant)
    }

    private func setUpButtons() {
        button.style = .primary
    }

    // MARK: Actions

    @IBAction func goToMyWhoppah(_: UIButton) {
        guard let tabsVC = getTabsVC() else { return }
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if self.userService.current == nil {
                tabsVC.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupMywhoppahTitle(),
                                                    description: R.string.localizable.contextualSignupMywhoppahDescription()) {
                    Navigator().navigate(route: Navigator.Route.myWhoppah(data: Navigator.MyWhoppahRoutingData(withMyAdSection: .none)))
                }
            } else {
                Navigator().navigate(route: Navigator.Route.myWhoppah(data: Navigator.MyWhoppahRoutingData(withMyAdSection: .none)))
            }
        }
    }
}
