//
//  NotificationSettingsCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/14/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol NotificationSettingsCellDelegate: AnyObject {
    func cellDidChangeValue(_ cell: NotificationSettingsCell, forNotificationType type: NotificationSettingsCell.NotificationType)
}

class NotificationSettingsCell: UITableViewCell {
    enum NotificationType {
        case pushUpdates
        case pushChat
        case emailUpdates
        case emailAccount
        case unknown
    }

    static let identifier = "NotificationSettingsCell"
    static let nibName = "NotificationSettingsCell"

    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var `switch`: UISwitch!

    // MARK: - Properties

    weak var delegate: NotificationSettingsCellDelegate?
    var notificationType: NotificationType = .unknown
    var config: NotificationSettingsViewController.NotificationConfig?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Actions

    @IBAction func switchAction(_: UISwitch) {
        delegate?.cellDidChangeValue(self, forNotificationType: notificationType)
    }

    func configure(with config: NotificationSettingsViewController.NotificationConfig) {
        self.config = config
        titleLabel.text = config.title
        descriptionLabel.text = config.description
        `switch`.isOn = config.value
        notificationType = config.notificationType
    }
}
