//
//  TrackCodeDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/5/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

protocol TrackCodeDialogDelegate: AnyObject {
    func trackCodeDialog(forOrder orderId: UUID, trackCode code: String)
}

class TrackCodeDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var trackCodeTextField: WPTextField!
    @IBOutlet var sendButton: UIButton!

    weak var delegate: TrackCodeDialogDelegate?
    var orderId: UUID!
    var trackCode: String = "" { didSet { sendButton.isEnabled = !trackCode.isEmpty } }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
    }

    // MARK: - Private

    private func setUpTextFields() {
        trackCodeTextField.delegate = self
        trackCodeTextField.placeholder = R.string.localizable.trackCodeTrackingNumberPlaceholder()
    }

    // MARK: - Actions

    @IBAction func sendAction(_: PrimaryLargeButton) {
        dismiss(animated: true, completion: nil)
        delegate?.trackCodeDialog(forOrder: orderId, trackCode: trackCode)
    }
}

// MARK: - UITextFieldDelegate

extension TrackCodeDialog: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        true
    }

    func textFieldDidBeginEditing(_: UITextField) {}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text!
        if textField == trackCodeTextField {
            trackCode = currentText
        }
    }
}
