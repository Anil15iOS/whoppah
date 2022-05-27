//
//  InvalidMediaViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 09/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class InvalidMediaViewController: UIViewController {
    enum MediaType {
        case image
        case video
    }

    // MARK: - IBOutlets

    @IBOutlet var subTitle: UILabel!
    @IBOutlet var backToPhotosButton: PrimaryLargeButton!
    var mediaType = MediaType.image

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpLabels()
        setUpButtons()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        let title: String!
        switch mediaType {
        case .image:
            title = R.string.localizable.create_ad_camera_invalidreview_photo_nav_title()
        case .video:
            title = R.string.localizable.create_ad_camera_invalidreview_video_nav_title()
        }

        setNavBar(title: title, enabled: true, transparent: false)
    }

    private func setUpLabels() {
        switch mediaType {
        case .image:
            subTitle.text = R.string.localizable.create_ad_camera_invalidreview_photo_subtitle()
        case .video:
            subTitle.text = R.string.localizable.create_ad_camera_invalidreview_video_subtitle()
        }
    }

    private func setUpButtons() {
        backToPhotosButton.style = .primary
        switch mediaType {
        case .image:
            backToPhotosButton.setTitle(R.string.localizable.create_ad_camera_invalidreview_upload_new_photo_button(), for: .normal)
        case .video:
            backToPhotosButton.setTitle(R.string.localizable.create_ad_camera_invalidreview_upload_new_video_button(), for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
