//
//  StyleSelectionCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

class StyleSelectionCell: UITableViewCell {
    static let nibName = "StyleSelectionCell"
    static let identifier = "StyleSelectionCell"

    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkBox: CheckBox!

    override func awakeFromNib() {
        super.awakeFromNib()

        checkBox.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with style: Style) {
        nameLabel.text = localizedString(style.title)?.capitalizingFirstLetter()
    }
}
