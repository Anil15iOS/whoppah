//
//  PaymentFailedDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 20/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class DraftSavingDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var loadingIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tapBackgroundToDismiss = false
        loadingIcon.startAnimating()
    }
}
