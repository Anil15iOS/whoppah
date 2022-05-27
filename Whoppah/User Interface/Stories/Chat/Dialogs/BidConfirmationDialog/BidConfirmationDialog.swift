//
//  BidConfirmationDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/1/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol BidConfirmationDialogDelegate: AnyObject {
    func bidConfirmationDialogDidTapYes(_ dialog: BidConfirmationDialog)
    func bidConfirmationDialogDidTapNo(_ dialog: BidConfirmationDialog)
}

class BidConfirmationDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var whoppahLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var yesButton: PrimaryLargeButton!
    @IBOutlet var noButton: SecondaryLargeButton!

    // MARK: - Properties

    var bidText: String!
    var bidId: UUID!
    weak var delegate: BidConfirmationDialogDelegate?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
        updateContent()
        updateStrings()
    }

    // MARK: - Private

    private func setUpButtons() {
        noButton.buttonColor = .shinyBlue
        yesButton.style = .shinyBlue
    }

    private func updateStrings() {
        whoppahLabel.text = "Whoppah!".uppercased()
    }

    private func updateContent() {
        titleLabel.text = R.string.localizable.bid_confirmation_accept_title(bidText!)
        messageLabel.text = ""
        yesButton.setTitle(R.string.localizable.bid_confirmation_accept_yes_button(), for: .normal)
        noButton.setTitle(R.string.localizable.bid_confirmation_no_button(), for: .normal)
    }

    // MARK: - Actions

    @IBAction func noAction(_: SecondaryLargeButton) {
        delegate?.bidConfirmationDialogDidTapNo(self)
    }

    @IBAction func yesAction(_: PrimaryLargeButton) {
        delegate?.bidConfirmationDialogDidTapYes(self)
    }
}
