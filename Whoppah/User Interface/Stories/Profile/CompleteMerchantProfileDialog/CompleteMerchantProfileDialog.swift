//
//  CompleteMerchantProfileDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 6/6/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class CompleteMerchantProfileDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var okButton: PrimaryLargeButton!

    // MARK: - Properties

    typealias OkTapped = () -> Void
    var onOkTapped: OkTapped?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }

    // MARK: - Private

    private func setUpButtons() {
        okButton.style = .shinyBlue
    }

    // MARK: - IBActions

    @IBAction func okAction(_: PrimaryLargeButton) {
        dismiss(animated: true, completion: onOkTapped)
    }
}
