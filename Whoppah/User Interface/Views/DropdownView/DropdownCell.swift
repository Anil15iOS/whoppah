//
//  DropdownCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/1/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Kingfisher
import UIKit

class DropdownCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "DropdownCell"
    static let nibName = "DropdownCell"

    // MARK: - IBOutlets

    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkBox: CheckBox!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        let backgroundView = UIView()
        backgroundView.backgroundColor = .flash
        selectedBackgroundView = backgroundView
        checkBox.isUserInteractionEnabled = false
    }

    // MARK: -

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: -

    func setUp(with item: DropdownItem) {
        nameLabel.text = item.name
        thumbnailView.isHidden = item.imageUrl == nil
        thumbnailView.setImage(forUrl: item.imageUrl)
        checkBox.isSelected = item.isSelected
    }
}
