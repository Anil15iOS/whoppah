//
//  PaymentConfirmationDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/4/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol PaymentConfirmationDialogDelegate: AnyObject {
    func paymentConfirmationDialogDidTapDetailsButton(_ dialog: PaymentConfirmationDialog)
}

class PaymentConfirmationDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var detailsButton: SecondaryLargeButton!

    // MARK: - Properties

    weak var delegate: PaymentConfirmationDialogDelegate?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }

    // MARK: - Private

    private func setUpButtons() {
        detailsButton.buttonColor = .blue
    }

    // MARK: - Actions

    @IBAction func detailsAction(_: SecondaryLargeButton) {
        delegate?.paymentConfirmationDialogDidTapDetailsButton(self)
    }
}
