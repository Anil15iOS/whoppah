//
//  WPAskTrackingIDCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/5/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

protocol WPAskTrackingIDCellDelegate: AnyObject {
    func askTrackingIDCellDidClickTrack(orderId: UUID)
}

class WPAskTrackingIDCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var trackIDButton: PrimaryLargeButton!

    // MARK: - Properties

    weak var askTrackingIDCellDelegate: WPAskTrackingIDCellDelegate?
    var avatarGestureRecognizer: UITapGestureRecognizer!

    // MARK: - Override

    override var bounds: CGRect {
        didSet {
            trackIDButton.layer.cornerRadius = trackIDButton.bounds.height / 2
        }
    }

    open override var message: MSGMessage? {
        didSet {
            guard let uiMessage = message else { return }
            guard case let MSGMessageBody.custom(body) = uiMessage.body else { return }
            guard let dataMessage = body as? ChatMessage else { return }
            guard case let .askTrackingID(payload) = dataMessage.type else { return }

            hasTrackingCode = payload.hasTrackingCode
        }
    }

    var hasTrackingCode: Bool = false {
        didSet {
            trackIDButton.isEnabled = !hasTrackingCode
        }
    }

    private var orderId: UUID? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .askTrackingID(payload) = dataMessage.type else { return nil }
        return payload.order
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        trackIDButton.style = .shinyBlue
        trackIDButton.layer.cornerRadius = trackIDButton.bounds.height / 2
        trackIDButton.clipsToBounds = true
    }

    // MARK: - Action

    @IBAction func trackIDAction(_: PrimaryLargeButton) {
        guard let order = orderId else { return }
        askTrackingIDCellDelegate?.askTrackingIDCellDidClickTrack(orderId: order)
    }
}
