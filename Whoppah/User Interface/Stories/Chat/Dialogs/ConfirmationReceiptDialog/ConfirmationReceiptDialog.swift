//
//  ConfirmationReceiptDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/5/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol ConfirmationReceiptDialogDelegate: AnyObject {
    func confirmationReceiptDialog(shouldSendFeedback received: Bool, text: String?, orderId: UUID)
}

class ConfirmationReceiptDialog: UIViewController {
    enum DeliveryMethod {
        case pickUp
        case delivery
    }

    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var yesButton: SecondaryLargeButton!
    @IBOutlet var yesCheckmarkView: UIImageView!
    @IBOutlet var didNotReceiveButton: SecondaryLargeButton!
    @IBOutlet var didNotReceiveCheckmarkView: UIImageView!
    @IBOutlet var noReasonTextfield: WPTextField!
    @IBOutlet var sendButton: PrimaryLargeButton!
    private let bag = DisposeBag()

    // MARK: - Properties

    weak var delegate: ConfirmationReceiptDialogDelegate?
    var orderId: UUID!
    var deliveryMethod: DeliveryMethod = .pickUp
    private var received = true

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()
        setUpTextFields()
        setUpNavigationBar()
        setUpButtons()
    }

    // MARK: - Private

    private func setUpTextFields() {
        let reasonText = noReasonTextfield.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
        Observable.combineLatest(reasonText, yesButton.rx.tap)
            .map { [weak self] result -> Bool in
                guard let self = self else { return false }
                if self.received { return true }
                if result.0 { return true }
                return false
            }.bind(to: sendButton.rx.isEnabled).disposed(by: bag)
        noReasonTextfield.placeholder = R.string.localizable.confirmReceiptReasonPlaceholder()
    }

    private func updateLabels() {
        questionLabel.text = deliveryMethod == .pickUp ? R.string.localizable.confirm_receipt_pickup_question_title() : R.string.localizable.confirm_receipt_delivery_question_title()

        let yesTitle = deliveryMethod == .pickUp ? R.string.localizable.confirm_receipt_pickup_yes_button() : R.string.localizable.confirm_receipt_delivery_yes_button()
        yesButton.setTitle(yesTitle, for: .normal)
        let notReceivedTitle = deliveryMethod == .pickUp ? R.string.localizable.confirm_receipt_pickup_no_button() : R.string.localizable.confirm_receipt_delivery_no_button()
        didNotReceiveButton.setTitle(notReceivedTitle, for: .normal)
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.track_code_navigation_title()
        navigationBar.backButton.setImage(R.image.ic_close(), for: .normal)
        navigationBar.backButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
    }

    private func setUpButtons() {
        selectReceived()
        sendButton.style = .primary
    }

    private func selectReceived() {
        received = true
        yesButton.buttonColor = .shinyBlue
        yesCheckmarkView.isHidden = false
        didNotReceiveButton.buttonColor = .steel
        didNotReceiveCheckmarkView.isHidden = true
        noReasonTextfield.resignFirstResponder()
        noReasonTextfield.isEnabled = false
    }

    private func selectNotReceived() {
        received = false
        yesButton.buttonColor = .steel
        yesCheckmarkView.isHidden = true
        didNotReceiveButton.buttonColor = .shinyBlue
        didNotReceiveCheckmarkView.isHidden = false
        noReasonTextfield.isEnabled = true
    }

    // MARK: - Actions

    @IBAction func sendAction(_: PrimaryLargeButton) {
        if received {
            delegate?.confirmationReceiptDialog(shouldSendFeedback: received,
                                                text: nil,
                                                orderId: orderId)
        } else {
            delegate?.confirmationReceiptDialog(shouldSendFeedback: received,
                                                text: noReasonTextfield.text, orderId: orderId)
        }
    }

    @IBAction func yesAction(_: SecondaryLargeButton) {
        selectReceived()
    }

    @IBAction func notReceivedAction(_: SecondaryLargeButton) {
        selectNotReceived()
    }

    @objc func closeAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
