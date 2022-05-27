//
//  SearchIntroDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 23/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class SearchIntroDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var uploadPhotoButton: PrimaryLargeButton!

    static func create() -> SearchIntroDialog? {
        SearchIntroDialog()
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }

    // MARK: - Private

    private func setUpButtons() {
        uploadPhotoButton.style = .primary
    }

    // MARK: - Actions
}
