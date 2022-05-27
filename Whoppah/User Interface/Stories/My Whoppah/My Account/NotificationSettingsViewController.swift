//
//  NotificationSettingsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/14/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class NotificationSettingsViewController: UIViewController {
    class NotificationConfig {
        let title: String
        let description: String
        var value: Bool
        var notificationType: NotificationSettingsCell.NotificationType = .unknown

        init(title: String, description: String, value: Bool) {
            self.title = title
            self.description = description
            self.value = value
        }
    }

    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var notificationTableView: UITableView!
    @IBOutlet var notificationsHeight: NSLayoutConstraint!
    @IBOutlet var emailSettingsLabel: UILabel!
    @IBOutlet var emailTableView: UITableView!
    @IBOutlet var emailHeight: NSLayoutConstraint!

    // MARK: - Properties

    private var notificationConfigs: [NotificationConfig] = []
    private var emailConfigs: [NotificationConfig] = []
    private var settings: NotificationSettings?

    @Injected fileprivate var user: WhoppahCore.LegacyUserService
    
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        generateData()
        setUpNavigationBar()
        setUpTableView()
        loadData()
    }

    // MARK: - Private

    private func loadData() {
        user.getNotificationSettings { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(settings):
                    self.settings = settings

                    self.notificationConfigs[0].value = settings.pushUpdates
                    self.notificationConfigs[1].value = settings.pushChat
                    self.notificationConfigs[2].value = settings.emailAccount

                    self.emailConfigs[0].value = settings.emailUpdates

                    self.notificationTableView.reloadData()
                    self.emailTableView.reloadData()
                case let .failure(error):
                    self.showError(error)
                }
            }
        }
    }

    private func generateData() {
        notificationConfigs.removeAll()
        let pushUpdates = NotificationConfig(title: R.string.localizable.my_account_notification_settings_push_updates_notif_title(),
                                             description: R.string.localizable.my_account_notification_settings_push_updates_notif_body(), value: false)
        pushUpdates.notificationType = .pushUpdates
        notificationConfigs.append(pushUpdates)
        let pushChat = NotificationConfig(title: R.string.localizable.my_account_notification_settings_push_chat_notif_title(),
                                          description: R.string.localizable.my_account_notification_settings_push_chat_notif_body(), value: false)
        pushChat.notificationType = .pushChat
        notificationConfigs.append(pushChat)
        let pushDescription = R.string.localizable.my_account_notification_settings_push_my_activities_notif_body()
        let pushAccount = NotificationConfig(title: R.string.localizable.my_account_notification_settings_push_my_activities_notif_title(),
                                             description: pushDescription, value: false)
        pushAccount.notificationType = .emailAccount
        notificationConfigs.append(pushAccount)

        emailConfigs.removeAll()
        let emailUpdates = NotificationConfig(title: R.string.localizable.my_account_notification_settings_email_my_activities_title(),
                                              description: R.string.localizable.my_account_notification_settings_email_my_activities_body(), value: false)
        emailUpdates.notificationType = .emailUpdates
        emailConfigs.append(emailUpdates)
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_account_settings()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpTableView() {
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        notificationTableView.register(UINib(nibName: NotificationSettingsCell.nibName, bundle: nil), forCellReuseIdentifier: NotificationSettingsCell.identifier)

        emailTableView.dataSource = self
        emailTableView.delegate = self
        emailTableView.register(UINib(nibName: NotificationSettingsCell.nibName, bundle: nil), forCellReuseIdentifier: NotificationSettingsCell.identifier)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension NotificationSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch tableView {
        case notificationTableView:
            var height: CGFloat = 0.0
            for config in notificationConfigs {
                let descriptionHeight = config.description.height(withConstrainedWidth: tableView.bounds.width - 16.0 - 75.0, font: UIFont.bodyText)
                let cellHeight = descriptionHeight + 52.0
                height += cellHeight
            }
            notificationsHeight.constant = height
            return notificationConfigs.count
        case emailTableView:
            var height: CGFloat = 0.0
            for config in emailConfigs {
                let descriptionHeight = config.description.height(withConstrainedWidth: tableView.bounds.width - 16.0 - 75.0, font: UIFont.bodyText)
                let cellHeight = descriptionHeight + 52.0
                height += cellHeight
            }
            emailHeight.constant = height
            return emailConfigs.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case notificationTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsCell.identifier) as! NotificationSettingsCell
            cell.configure(with: notificationConfigs[indexPath.row])
            cell.delegate = self
            return cell
        case emailTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsCell.identifier) as! NotificationSettingsCell
            cell.configure(with: emailConfigs[indexPath.row])
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension NotificationSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case notificationTableView:
            let descriptionHeight = notificationConfigs[indexPath.row].description.height(withConstrainedWidth: tableView.bounds.width - 16.0 - 75.0, font: UIFont.bodyText)
            return descriptionHeight + 52.0
        case emailTableView:
            let descriptionHeight = emailConfigs[indexPath.row].description.height(withConstrainedWidth: tableView.bounds.width - 16.0 - 75.0, font: UIFont.bodyText)
            return descriptionHeight + 52.0
        default:
            return 0.0
        }
    }
}

// MARK: - NotificationSettingsCellDelegate

extension NotificationSettingsViewController: NotificationSettingsCellDelegate {
    func cellDidChangeValue(_ cell: NotificationSettingsCell, forNotificationType type: NotificationSettingsCell.NotificationType) {
        switch type {
        case .pushChat:
            settings?.pushChat = cell.switch.isOn
        case .pushUpdates:
            settings?.pushUpdates = cell.switch.isOn
        case .emailUpdates:
            settings?.emailUpdates = cell.switch.isOn
        case .emailAccount:
            settings?.emailAccount = cell.switch.isOn
        default:
            break
        }

        guard let settings = settings else { return }
        user.updateNotificationSettings(settings: settings) { result in
            switch result {
            case let .success(settings):
                self.settings = settings
            case let .failure(error):
                self.showError(error)
            }
        }
    }
}
