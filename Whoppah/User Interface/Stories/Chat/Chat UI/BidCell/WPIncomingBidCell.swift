//
//  WPIncomingBidCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/7/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

protocol WPIncomingBidCellDelegate: AnyObject {
    func incomingBidCellDidClickAccept(_ cell: WPIncomingBidCell, buttonView: UIView)
    func incomingBidCellDidClickDeny(_ cell: WPIncomingBidCell, buttonView: UIView)
    func incomingBidCellDidClickCounter(_ cell: WPIncomingBidCell, buttonView: UIView)
}

extension BidPayload {
    var displayTitle: Bool {
        status != .new
    }
}

class WPIncomingBidCell: MSGMessageCell {
    // MARK: - IBOutlets

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var bubble: WPBubble!
    @IBOutlet var bidStatusLabel: UILabel!
    @IBOutlet var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    @IBOutlet var counterButton: UIButton!

    private lazy var allButtons = [acceptButton, rejectButton, counterButton]

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            guard let uiMessage = message else { return }
            guard case let MSGMessageBody.custom(body) = uiMessage.body else { return }
            guard let dataMessage = body as? ChatMessage else { return }
            guard case let .bid(payload) = dataMessage.type else { return }

            avatarView!.loadChatAvatar(message)

            let bidAmount = payload.amount.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true)

            bidStatusLabel.text = payload.status.title.localizedUppercase
            bubble.textview.text = R.string.localizable.chatCellIncomingBidNew()
            bidStatusLabel.isVisible = payload.displayTitle
            allButtons.forEach { $0?.isVisible = (payload.status == .new) }

            switch payload.status {
            case .new:
                bubble.textview.text = R.string.localizable.chatCellIncomingBidNew()
                bubble.textview.textColor = R.color.chatCellRightNavy()
                bubble.rightSection = WPBubble.RightSection(backgroundColor: R.color.chatCellRightNavy()!, textColor: .white, text: bidAmount)
                bubble.leftImage = R.image.chatCellNewIcon()
            case .accepted, .processing, .completed:
                // Use a custom status for accepted/processing
                if payload.status != .completed {
                    bidStatusLabel.text = R.string.localizable.bidStateAccepted().localizedUppercase
                }
                bidStatusLabel.textColor = R.color.chatCellRightNavy()
                bubble.rightSection = WPBubble.RightSection(backgroundColor: .greenValidation, textColor: .white, text: bidAmount)
                bubble.leftImage = R.image.chatCellAcceptedIcon()
            case .rejected, .canceled:
                bubble.textview.textColor = R.color.chatCellRightExpired()
                bidStatusLabel.textColor = .redInvalid
                bubble.rightSection = WPBubble.RightSection(backgroundColor: R.color.chatCellRightExpired()!, textColor: .white, text: bidAmount)
                bubble.leftImage = R.image.chatCellRejectedIcon()
            case .expired:
                bidStatusLabel.textColor = R.color.chatCellRightExpired()
                bubble.textview.textColor = R.color.chatCellRightExpired()
                bubble.rightSection = WPBubble.RightSection(backgroundColor: R.color.chatCellRightExpired()!, textColor: .white, text: bidAmount)
                bubble.leftImage = R.image.chatCellExpiredIcon()
            case let .__unknown(raw):
                assertionFailure(raw)
            }
        }
    }

    // MARK: - Properties

    weak var bidCellDelegate: WPIncomingBidCellDelegate?
    var avatarGestureRecognizer: UITapGestureRecognizer!

    var bidId: UUID? {
        bidPayload?.id
    }

    var productId: UUID? {
        bidPayload?.productId
    }

    var auctionId: UUID? {
        bidPayload?.auctionId
    }

    var buyerId: UUID? {
        bidPayload?.buyerId
    }

    var amount: PriceInput? { bidPayload?.amount }

    // MARK: - Override

    private var bidPayload: BidPayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .bid(payload) = dataMessage.type else { return nil }
        return payload
    }

    var isDisabled: Bool = false

    override var isLastInSection: Bool {
        didSet {
            guard let message = message else { return }
            if !message.user.isSender {
                avatarView?.isHidden = !isLastInSection
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView?.layer.cornerRadius = 17.0
        avatarView?.layer.masksToBounds = true

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true

        bubbleView.layer.cornerRadius = 4.0
        setupButtons()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let adjustedSize = CGSize(width: bounds.size.width - bubble.frame.minX - 16, height: bounds.size.height)
        let bubbleSize = bubble.calculatedSize(in: adjustedSize)
        bubbleWidthConstraint.constant = bubbleSize.width
    }

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }

    // MARK: - Actions

    @IBAction func acceptAction(_: UIButton) {
        guard !isDisabled else { return }
        bidCellDelegate?.incomingBidCellDidClickAccept(self, buttonView: buttonView)
    }

    @IBAction func denyAction(_: UIButton) {
        guard !isDisabled else { return }
        bidCellDelegate?.incomingBidCellDidClickDeny(self, buttonView: buttonView)
    }

    @IBAction func counterAction(_: UIButton) {
        guard !isDisabled else { return }
        bidCellDelegate?.incomingBidCellDidClickCounter(self, buttonView: buttonView)
    }

    private func setupButtons() {
        setupButton(button: acceptButton, color: .greenValidation)
        setupButton(button: rejectButton, color: .redInvalid)
        setupButton(button: counterButton, color: .shinyBlue)
    }

    private func setupButton(button: UIButton, color: UIColor) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
    }

    static func size(forSize size: CGSize, payload: BidPayload) -> CGSize {
        var buttonHeight: CGFloat = 0
        if payload.status == .new {
            buttonHeight = 40 * 3 + 2 * 8
        }
        if payload.displayTitle {
            return CGSize(width: size.width, height: 60.0 + buttonHeight)
        }
        return CGSize(width: size.width, height: 40.0 + buttonHeight)
    }
}
