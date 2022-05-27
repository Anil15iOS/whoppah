//
//  NoResultsdialog.swift
//  Whoppah
//
//  Created by Eddie Long on 24/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import UIKit

class NoMapSearchResultsDialog: BaseDialog {
    // MARK: Outlets

    @IBOutlet var filtersButton: PrimaryLargeButton!

    // MARK: Properties

    typealias FiltersSelected = () -> Void
    var onFiltersSelected: FiltersSelected?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
    }

    private func setUpButtons() {
        filtersButton.style = .primary
    }

    // MARK: IBAction

    @IBAction func filterAction(_: PrimaryLargeButton) {
        dismiss(animated: true) {
            self.onFiltersSelected?()
        }
    }
}
