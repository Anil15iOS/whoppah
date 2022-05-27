//
//  FilterControlCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/26/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class FilterControlCell: UICollectionViewCell {
    static let identifier = "FilterControlCell"
    static let nibName = "FilterControlCell"

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false
        layer.cornerRadius = 16.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4.0
        layer.shadowOffset = .zero
    }

    func configure(with item: FilterControlItem) {
        nameLabel.text = item.title
        iconView.image = item.icon
    }
}
