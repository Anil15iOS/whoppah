//
//  WhoppahNavigationController.swift
//  Whoppah
//
//  Created by Eddie Long on 13/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

// Used morely for styling of UIAppearance
class WhoppahNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func navigationController(_: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
