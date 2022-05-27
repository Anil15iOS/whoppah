//
//  WPOutgoingBidCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/7/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

protocol WPOutgoingBidCellDelegate: AnyObject {
    func outgoingBidBidPressed(cell: WPOutgoingBidCell, buttonView: UIView, reloadMessages: Bool)
}

class WPOutgoingBidCell: MSGMessageCell {
    // MARK: - IBOutlets

    static let OutgoingBidDialogTag = 112_233
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var bubble: WPBubble!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet var bidStatusLabel: UILabel!
    @IBOutlet var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bidButton: UIButton!

    weak var cellDelegate: WPOutgoingBidCellDelegate?

    var bidId: UUID? {
        payload?.id
    }

    private static func showBidButton(payload: BidPayload) -> Bool {
        guard payload.biddingEnabled else { return false }
        switch payload.status {
        case .expired, .canceled, .rejected:
            return true
        default:
            return false
        }
    }

    // Whether we're showing the bid dialog as a child
    var isExpanded: Bool = false {
        didSet {
            refreshBidDialog()
        }
    }

    private func refreshBidDialog() {
        guard let payload = payload else { return }
        let allowBid = WPOutgoingBidCell.showBidButton(payload: payload)
        buttonViewHeight.isActive = !isExpanded && allowBid
        bidButton.isVisible = !isExpanded && allowBid
        buttonView.isVisible = isExpanded
    }

    private var payload: BidPayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .bid(payload) = dataMessage.type else { return nil }
        return payload
    }

    // MARK: - Override

    open override var message: MSGMessage? {
        didSet {
            guard let payload = payload else { return }
            let bidAmount = payload.amount.formattedPrice(includeCurrency: true, clipRemainderIfZero: true, showFraction: true)

            bidStatusLabel.text = payload.status.title.localizedUppercase
            bubble.textview.text = R.string.localizable.chatCellOutgoingBidNew()
            bidStatusLabel.isVisible = true
            switch payload.status {
            case .new:
                bidStatusLabel.isVisible = false
                bubble.textview.text = R.string.localizable.chatCellOutgoingBidNew()
                bubble.textview.textColor = R.color.chatCellRightNavy()
                bubble.rightSection = WPBubble.RightSection(backgroundColor: R.color.chatCellRightNavy()!, textColor: .white, text: bidAmount)
                bubble.leftImage = R.image.chatCellNewIcon()
            case .accepted, .processing, .completed:
                // Use a custom status for accepted/processing
                if payload.status != .completed {
                    bidStatusLabel.text = R.string.localizable.bidStateAccepted().localizedUppercase
                }
                bubble.textview.textColor = R.color.chatCellRightNavy()
                bidStatusLabel.textColor = .greenValidation
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

            if isExpanded {
                cellDelegate?.outgoingBidBidPressed(cell: self, buttonView: buttonView, reloadMessages: false)
            } else {
                if let view = viewWithTag(WPOutgoingBidCell.OutgoingBidDialogTag) {
                    view.removeFromSuperview()
                }
            }

            refreshBidDialog()
        }
    }

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()

        bubble.direction = .right
        bubble.color = R.color.chatCellBackgroundOutgoing()!

        bidButton.layer.cornerRadius = bidButton.bounds.height / 2
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let adjustedSize = CGSize(width: bounds.size.width - bubble.frame.minX - 16, height: bounds.size.height)
        let bubbleSize = bubble.calculatedSize(in: adjustedSize)
        bubbleWidthConstraint.constant = bubbleSize.width
    }

    @IBAction func newBidClicked(_: UIButton) {
        cellDelegate?.outgoingBidBidPressed(cell: self, buttonView: buttonView, reloadMessages: true)
    }

    static func size(forSize size: CGSize, payload: BidPayload, isExpanded: Bool) -> CGSize {
        var height: CGFloat = 40
        if payload.displayTitle {
            height = 56.0
        }

        if isExpanded {
            height += 146
        } else {
            height += WPOutgoingBidCell.showBidButton(payload: payload) ? 47 : 0
        }

        return CGSize(width: size.width, height: height)
    }
}
