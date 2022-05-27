//
//  WPTrackingIDCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/5/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

class WPTrackingIDCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var bubbleView: UIView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var trackNumberView: UIView!
    @IBOutlet var courierView: UIView!
    @IBOutlet var trackNumberTitleLabel: UILabel!
    @IBOutlet var trackNumberLabel: UILabel!
    @IBOutlet var providerTitleLabel: UILabel!
    @IBOutlet var returnNumberView: UIView!
    @IBOutlet var returnNumberTitleLabel: UILabel!
    @IBOutlet var returnNumberLabel: UILabel!
    @IBOutlet var statusBackgroundView: UIView!
    @IBOutlet var statusLabel: UILabel!

    // MARK: - Properties

    var avatarGestureRecognizer: UITapGestureRecognizer!

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            guard let uiMessage = message else { return }
            guard case let MSGMessageBody.custom(body) = uiMessage.body else { return }
            guard let dataMessage = body as? ChatMessage else { return }
            guard case let .trackingID(payload) = dataMessage.type else { return }

            courierView.isVisible = payload.isCourier

            if !payload.isCourier, let trackingNumber = payload.trackingID {
                trackNumberLabel.text = trackingNumber
                trackNumberView.isHidden = false
            } else {
                trackNumberView.isHidden = true
            }

            if !payload.isCourier, let returnNumber = payload.returnID {
                returnNumberLabel.text = returnNumber
                returnNumberView.isHidden = false
            } else {
                returnNumberView.isHidden = true
            }

            avatarView!.loadChatAvatar(message)
        }
    }

    var isFirstInSection: Bool = false {
        didSet {
            avatarView?.isHidden = !isFirstInSection
        }
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        bubbleView.layer.cornerRadius = 4.0
        bubbleView.layer.borderColor = UIColor.smoke.cgColor
        bubbleView.layer.borderWidth = 1.0

        avatarView?.layer.cornerRadius = 17.0
        avatarView?.layer.masksToBounds = true

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true

        statusBackgroundView.layer.cornerRadius = statusBackgroundView.bounds.height / 2
    }

    // MARK: - Action

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }
}
