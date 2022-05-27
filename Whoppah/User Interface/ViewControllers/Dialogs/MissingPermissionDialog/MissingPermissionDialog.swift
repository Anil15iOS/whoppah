//
//  MissingPermissionDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 09/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

enum MissingPermissionType {
    case camera
    case location
}

class MissingPermissionDialog: BaseDialog {
    // MARK: Outlets

    @IBOutlet var okButton: SecondaryLargeButton!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    private let type: MissingPermissionType

    static func create(forPermission type: MissingPermissionType) -> MissingPermissionDialog {
        let dialog = MissingPermissionDialog(forPermission: type)
        return dialog
    }

    init(forPermission type: MissingPermissionType) {
        self.type = type
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpIcon()
        setUpText()
    }

    // MARK: Private

    private func setUpIcon() {
        switch type {
        case .location:
            icon.image = R.image.no_location_permission_title_image()
        case .camera:
            icon.image = R.image.no_camera_permission_image()
        }
    }

    private func setUpText() {
        switch type {
        case .location:
            titleLabel.text = R.string.localizable.missing_permission_location_title()
            subtitleLabel.text = R.string.localizable.missing_permission_location_subtitle()
        case .camera:
            titleLabel.text = R.string.localizable.missing_permission_camera_title()
            subtitleLabel.text = R.string.localizable.missing_permission_camera_subtitle()
        }
    }

    // MARK: Actions

    @IBAction func okPressed(_: UIButton) {
        showSettingsApp { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
