//
//  PaymentFailedDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 20/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class PaymentFailedDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var paymentButton: PrimaryLargeButton!

    // MARK: - Properties

    typealias PaymentTapped = () -> Void
    var onPaymentButtonTapped: PaymentTapped?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }

    private func setUpButtons() {
        paymentButton.style = .shinyBlue
    }

    // MARK: - Actions

    @IBAction func paymentAction(_: UIButton) {
        dismiss(animated: true) {
            self.onPaymentButtonTapped?()
        }
    }
}
