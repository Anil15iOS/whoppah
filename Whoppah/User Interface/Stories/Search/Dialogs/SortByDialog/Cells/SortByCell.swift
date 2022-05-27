//
//  SortByCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class SortByCell: UITableViewCell {
    static let identifier = "SortByCell"
    static let nibName = "SortByCell"

    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var radioButton: RadioButton!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        radioButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with title: String) {
        nameLabel.text = title
    }
}
