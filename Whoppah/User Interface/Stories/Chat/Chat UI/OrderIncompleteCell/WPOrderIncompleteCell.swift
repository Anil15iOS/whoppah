//
//  WPOrderIncompleteCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/3/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import RxSwift
import UIKit
import WhoppahCore

protocol WPOrderIncompleteCellDelegate: AnyObject {
    func orderIncompleteBidPressed(cell: WPOrderIncompleteCell, buttonView: UIView, reloadMessages: Bool)
}

class WPOrderIncompleteCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var bubbleView: UIView!
    @IBOutlet var avatarView: UIImageView!

    @IBOutlet var bubbleTitle: UILabel!
    @IBOutlet var bubbleDescription: UILabel!

    @IBOutlet var buttonView: UIView!
    @IBOutlet var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet var bidButton: UIButton!

    // Whether we're showing the bid dialog as a child
    var isExpanded: Bool = false {
        didSet {
            buttonViewHeight.isActive = !isExpanded
            buttonView.isVisible = isExpanded
        }
    }

    var orderId: UUID? { payload?.orderID }

    // MARK: - Properties

    var avatarGestureRecognizer: UITapGestureRecognizer!
    weak var cellDelegate: WPOrderIncompleteCellDelegate?

    // MARK: - Override

    private var payload: OrderIncompletePayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .orderIncomplete(payload) = dataMessage.type else { return nil }
        return payload
    }

    open override var message: MSGMessage? {
        didSet {
            guard let payload = payload else { return }
            bubbleDescription.text = payload.text
            switch payload.state {
            case .canceled:
                bubbleTitle.text = R.string.localizable.chatCellOrderIncompleteOrderCancelledTitle()
                bubbleTitle.backgroundColor = R.color.rejectDialogColor()
            case .expired:
                bubbleTitle.text = R.string.localizable.chatCellOrderIncompleteOrderExpiredTitle()
                bubbleTitle.backgroundColor = R.color.chatCellRightExpired()
            default:
                fatalError("Unexpected payload state \(payload.state)")
            }

            bidButton.isEnabled = payload.biddingEnabled
            avatarView?.loadChatAvatar(message)
        }
    }

    override var isLastInSection: Bool {
        didSet {
            avatarView?.isHidden = !isLastInSection
        }
    }

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 20.0
        bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        bubbleView.layer.borderColor = UIColor.smoke.cgColor
        bubbleView.layer.borderWidth = 1.0

        avatarView?.layer.cornerRadius = 17.0
        avatarView?.layer.masksToBounds = true

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true

        bidButton.layer.cornerRadius = bidButton.bounds.height / 2
    }

    // MARK: - Action

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }

    @IBAction func newBidClicked(_: UIButton) {
        cellDelegate?.orderIncompleteBidPressed(cell: self, buttonView: buttonView, reloadMessages: true)
    }

    static func size(forSize size: CGSize, payload: OrderIncompletePayload, isExpanded: Bool) -> CGSize {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = payload.text
        label.numberOfLines = 0

        let leading: CGFloat = 58
        let trailing: CGFloat = 72
        let padding: CGFloat = 16
        let availableSize = CGSize(width: size.width - padding * 2 - leading - trailing, height: .infinity)
        let labelSize = label.textRect(forBounds: CGRect(x: 0, y: 0, width: availableSize.width, height: .infinity), limitedToNumberOfLines: 0).size
        let headerHeight: CGFloat = 48
        let buttonTopPadding: CGFloat = 8
        let buttonSize: CGFloat = 39
        var height: CGFloat = headerHeight + labelSize.height + padding * 2 + buttonTopPadding + buttonSize
        if isExpanded {
            height += 146
        }
        return CGSize(width: size.width, height: height)
    }
}
