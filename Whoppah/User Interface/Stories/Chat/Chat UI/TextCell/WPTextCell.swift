//
//  WPTextCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import UIKit
import WhoppahCore

class WPTextCell: MSGMessageCell {
    @IBOutlet var bubble: WPBubble!
    @IBOutlet var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet var avatarView: UIImageView?

    var avatarGestureRecognizer: UITapGestureRecognizer!
    private let leftAvatarViewWidth: CGFloat = 58 // Empty for incoming text
    private let rightMargin: CGFloat = 16
    // We don't want the message to _all the way_ across to the other size
    // Makes it a little difficult to distinguish between the two kinds of cells (incoming and outgoing)
    private let extraPadding: CGFloat = 40

    convenience init() {
        self.init(frame: .zero)
        bubble = WPBubble()
    }

    open override var message: MSGMessage? {
        didSet {
            if let message = message, case let MSGMessageBody.text(body) = message.body {
                bubble.textview.text = body
            } else if let message = message, case let MSGMessageBody.custom(body) = message.body {
                guard let dataMessage = body as? ChatMessage else { return }
                guard case let .text(payload) = dataMessage.type else { return }
                bubble.textview.text = payload.text
            }

            avatarView?.loadChatAvatar(message)
        }
    }

    override var style: MSGMessengerStyle? {
        didSet {
            guard let style = style as? WPChatStyle, let message = message, let user = message.user as? ChatUser else { return }
            bubble.textview.linkTextAttributes[NSAttributedString.Key.underlineColor] = style.outgoingLinkColor
            bubble.textview.linkTextAttributes[NSAttributedString.Key.foregroundColor] = style.outgoingLinkColor
            bubble.textview.font = style.font

            if user.isSender {
                bubble.direction = .right
                bubble.color = R.color.chatCellBackgroundOutgoing()!
            } else {
                bubble.direction = .left
                bubble.color = R.color.chatCellBackgroundIncoming()!
            }
            bubble.textview.textColor = message.user.isSender ? style.outgoingTextColor : style.incomingTextColor
        }
    }

    override var isLastInSection: Bool {
        didSet {
            guard let message = message else { return }
            if !message.user.isSender {
                avatarView?.isHidden = !isLastInSection
            }
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let bubbleSize = calculatedSize(in: CGSize(width: bounds.width, height: .infinity))
        bubbleWidthConstraint.constant = bubbleSize.width
    }

    func calculatedSize(in size: CGSize) -> CGSize {
        let adjustedSize = CGSize(width: size.width - leftAvatarViewWidth - rightMargin - extraPadding, height: size.height)
        return bubble.calculatedSize(in: adjustedSize)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView?.layer.masksToBounds = true

        avatarGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView?.addGestureRecognizer(avatarGestureRecognizer)
        avatarView?.isUserInteractionEnabled = true
    }

    @objc func avatarTapped(_: UITapGestureRecognizer) {
        guard let user = message?.user else { return }
        delegate?.cellAvatarTapped(for: user)
    }
}
