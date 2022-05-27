//
//  WPAskPayCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/3/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

protocol WPAskPayCellDelegate: AnyObject {
    func askPayCellDidClickBuy(payload: AskPayPayload)
}

class WPAskPayCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var payButton: PrimaryLargeButton!
    @IBOutlet var payNowDialog: UIView!

    // MARK: - Properties

    weak var askPayCellDelegate: WPAskPayCellDelegate?
    var avatarGestureRecognizer: UITapGestureRecognizer!

    private var payload: AskPayPayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .askPay(payload) = dataMessage.type else { return nil }
        return payload
    }

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            guard let payload = self.payload else { return }
            isPaid = payload.isPaid
            avatarView!.loadChatAvatar(message)
        }
    }

    override var isLastInSection: Bool {
        didSet {
            avatarView?.isHidden = !isLastInSection
        }
    }

    private var isPaid: Bool = false {
        didSet {
            payButton.isEnabled = !isPaid
        }
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true

        payNowDialog.layer.cornerRadius = 10
        payNowDialog.layer.masksToBounds = true
        payNowDialog.layer.borderColor = UIColor.smoke.cgColor
        payNowDialog.layer.borderWidth = 1
    }

    // MARK: - Action

    @IBAction func payAction(_: PrimaryLargeButton) {
        guard let payload = payload else { return }
        askPayCellDelegate?.askPayCellDidClickBuy(payload: payload)
    }

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }

    static func size(forSize size: CGSize, payload _: AskPayPayload) -> CGSize {
        let text = R.string.localizable.chatAskPayCellPayNowDescription()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = text
        label.numberOfLines = 0

        let leading: CGFloat = 58
        let trailing: CGFloat = 72
        let padding: CGFloat = 16
        let availableSize = CGSize(width: size.width - padding * 2 - leading - trailing, height: .infinity)
        let labelSize = label.textRect(forBounds: CGRect(x: 0, y: 0, width: availableSize.width, height: .infinity), limitedToNumberOfLines: 0).size
        let buttonHeight: CGFloat = 48
        let headerHeight: CGFloat = 38
        let height: CGFloat = headerHeight + labelSize.height + buttonHeight + 8 + padding * 2
        return CGSize(width: size.width, height: height)
    }
}
