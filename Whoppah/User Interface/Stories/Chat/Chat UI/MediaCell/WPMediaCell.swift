//
//  WPMediaCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MessengerKit
import RxSwift
import UIKit
import WhoppahCore

protocol WPMediaCellDelegate: AnyObject {
    func didTapMedia(payload: MediaPayload)
}

class WPMediaCell: MSGMessageCell {
    @IBOutlet var avatarView: UIImageView?
    @IBOutlet var mediaView: MediaView!
    @IBOutlet var loadingView: UIImageView?

    private let bag = DisposeBag()
    weak var mediaDelegate: WPMediaCellDelegate?

    private static let leftAvatarViewWidth: CGFloat = 58 // Empty for incoming text
    private static let rightMargin: CGFloat = 72

    convenience init() {
        self.init(frame: .zero)
    }

    private var payload: MediaPayload? {
        guard let uiMessage = message else { return nil }
        guard case let MSGMessageBody.custom(body) = uiMessage.body else { return nil }
        guard let dataMessage = body as? ChatMessage else { return nil }
        guard case let .media(payload) = dataMessage.type else { return nil }
        return payload
    }

    open override var message: MSGMessage? {
        didSet {
            guard let payload = payload else { return }
            switch payload.type {
            case .image:
                switch payload.data {
                case let .existing(url):
                    mediaView.thumbnailView.setImage(forUrl: url)

                case let .local(data):
                    mediaView.thumbnailView.image = UIImage(data: data)
                    loadingView?.startAnimating()
                    loadingView?.isVisible = true
                }
                mediaView.showControls = false
                mediaView.showScrubber = false
            case .video:
                switch payload.data {
                case let .existing(url):
                    mediaView.configure(videoUrl: url)
                case let .local(data):
                    mediaView.configure(data: data)
                    loadingView?.startAnimating()
                    loadingView?.isVisible = true
                }

                mediaView.showControls = true
                mediaView.showScrubber = true
            }
            avatarView?.loadChatAvatar(message)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView?.layer.masksToBounds = true

        let avatarTap = UITapGestureRecognizer()
        avatarTap.rx.event.bind { [weak self] _ in
            guard let self = self else { return }
            guard let user = self.message?.user else { return }
            self.delegate?.cellAvatarTapped(for: user)
        }.disposed(by: bag)
        avatarView?.addGestureRecognizer(avatarTap)
        avatarView?.isUserInteractionEnabled = true

        mediaView.thumbnailView.contentMode = .scaleAspectFill
        mediaView.delegate = self
    }

    static func size(forSize size: CGSize, payload _: MediaPayload) -> CGSize {
        // Media is square
        let height = size.width - WPMediaCell.rightMargin - WPMediaCell.leftAvatarViewWidth
        return CGSize(width: size.width, height: height)
    }
}

extension WPMediaCell: MediaViewDelegate {
    func mediaViewDidSelect(_: MediaView, at _: Int?) {
        guard let payload = self.payload else { return }
        mediaDelegate?.didTapMedia(payload: payload)
    }

    func videoDidStart(_: MediaView) {}
    func videoDidEnd() {}
}
