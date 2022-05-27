//
//  ThreadCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class ThreadCell: UITableViewCell {
    static let identifier = "ThreadCell"
    static let nibName = "ThreadCell"

    // MARK: - IBOutlets

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var adImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var unreadMessageView: UIView!
    @IBOutlet var unreadMessageLabel: UILabel!

    weak var viewModel: ThreadOverviewCellViewModel?
    private var bag: DisposeBag!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarView.makeCircular()

        adImageView.layer.cornerRadius = 4.0
        adImageView.layer.masksToBounds = true

        unreadMessageView.layer.cornerRadius = unreadMessageView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with thread: ThreadOverviewCellViewModel) {
        bag = DisposeBag()
        viewModel = thread
        if !thread.isBusiness {
            if let url = thread.avatarURL {
                avatarView!.kf.setImage(with: url, placeholder: EmptyAvatarImage.create(letter: thread.avatar, size: avatarView!.frame.size))
            } else {
                avatarView!.image = EmptyAvatarImage.create(letter: thread.avatar, size: avatarView!.frame.size)
            }
        } else {
            avatarView.kf.setImage(with: thread.threadImage, placeholder: EmptyAvatarImage.create(letter: thread.avatar, size: avatarView!.frame.size))
        }

        usernameLabel.text = thread.username
        if !thread.isBusiness {
            adImageView.setImage(forUrl: thread.threadImage)
        } else {
            adImageView.isHidden = true
        }
        dateLabel.text = thread.date
        dateLabel.isVisible = true

        lastMessageLabel.text = thread.lastMessageText

        thread.numberOfUnreadMessages.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }
            let hasNew = count != 0 // swiftlint:disable:this empty_count
            self.backgroundColor = hasNew ? UIColor(hexString: "#F3F4F6") : .white
            self.unreadMessageLabel.text = "\(count)"
            self.unreadMessageView.isHidden = !hasNew
            self.unreadMessageLabel.isHidden = !hasNew
        }).disposed(by: bag)
    }

    override func prepareForReuse() {
        if isSkeletonActive {
            contentView.backgroundColor = .white
            dateLabel.isVisible = true
            lastMessageLabel.isVisible = true
            usernameLabel.isVisible = true
            unreadMessageLabel.isVisible = false
            unreadMessageView.isVisible = false
        }
    }
}
