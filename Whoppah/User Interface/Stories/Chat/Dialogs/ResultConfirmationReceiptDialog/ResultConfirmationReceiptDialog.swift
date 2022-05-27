//
//  ResultConfirmationReceiptDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/5/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

class ResultConfirmationReceiptDialog: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!

    var received = true

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        updateContent()
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.transaction_feedback_title()
        navigationBar.backButton.setImage(R.image.ic_close(), for: .normal)
        navigationBar.backButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
    }

    private func updateContent() {
        imageView.image = received ? R.image.w_bg() : R.image.stars_bg()
        titleLabel.text = received ? R.string.localizable.transaction_feedback_positive_title() : R.string.localizable.transaction_feedback_negative_title()
        let positiveMessage = R.string.localizable.transaction_feedback_positive_body()
        let negativeMessage = R.string.localizable.transaction_feedback_negative_body()
        messageLabel.text = received ? positiveMessage : negativeMessage
    }

    // MARK: - Actions

    @objc func closeAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backToChatAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
