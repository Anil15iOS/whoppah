//
//  WPDidReceiveProductCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/4/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

protocol DidReceiveProductCellDelegate: AnyObject {
    func didReceiveProductToggleDialog(orderID: UUID, show: Bool)
    func didReceiveProductGoodOrder(orderID: UUID)
    func didReceiveProductNotGoodOrder(orderID: UUID)
}

class WPDidReceiveProductCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var receivedButton: PrimaryLargeButton!

    @IBOutlet var buttonDialogView: UIView!

    // MARK: - Properties

    weak var didReceiveProductDelegate: DidReceiveProductCellDelegate?

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarView.makeCircular()

        buttonDialogView.layer.cornerRadius = 10
        buttonDialogView.layer.borderColor = UIColor.shinyBlue.cgColor
        buttonDialogView.layer.borderWidth = 1
        receivedButton.layer.cornerRadius = receivedButton.bounds.height / 2
    }

    private var payload: ProductReceivedPayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .didProductReceived(payload) = dataMessage.type else { return nil }
        return payload
    }

    var showDialog: Bool = true {
        didSet {
            buttonDialogView.isVisible = showDialog
            if showDialog {
                sendSubviewToBack(receivedButton)
            } else {
                bringSubviewToFront(receivedButton)
            }
        }
    }

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            guard let payload = payload else { return }
            receiveState = payload.receiveState
            avatarView!.loadChatAvatar(message)
            buttonDialogView.isVisible = showDialog
        }
    }

    private var receiveState: ProductReceivedPayload.ReceiveState = .notReceived {
        didSet {
            switch receiveState {
            case .received:
                receivedButton.setTitle(R.string.localizable.item_received_button_money_received(), for: .normal)
                receivedButton.isEnabled = false
            case .notReceived:
                receivedButton.setTitle(R.string.localizable.chatCellProductReceivedReceivedButton(), for: .normal)
                receivedButton.isEnabled = true
            }
        }
    }

    override var isLastInSection: Bool {
        didSet {
            avatarView?.isHidden = !isLastInSection
        }
    }

    // MARK: - Actions

    @IBAction func showDialogButton(_: UIButton) {
        guard let payload = payload else { return }
        didReceiveProductDelegate?.didReceiveProductToggleDialog(orderID: payload.orderID, show: true)
    }

    @IBAction func closeDialogButton(_: UIButton) {
        guard let payload = payload else { return }
        didReceiveProductDelegate?.didReceiveProductToggleDialog(orderID: payload.orderID, show: false)
    }

    @IBAction func receivedAction(_: UIButton) {
        guard let payload = payload else { return }
        receiveState = payload.receiveState
        didReceiveProductDelegate?.didReceiveProductGoodOrder(orderID: payload.orderID)
    }

    @IBAction func notReceivedAction(_: UIButton) {
        guard let payload = payload else { return }
        didReceiveProductDelegate?.didReceiveProductNotGoodOrder(orderID: payload.orderID)
    }

    static func size(forSize size: CGSize, payload _: ProductReceivedPayload, showDialog: Bool) -> CGSize {
        guard !showDialog else {
            return CGSize(width: size.width, height: 202.0)
        }
        return CGSize(width: size.width, height: 40.0)
    }
}
