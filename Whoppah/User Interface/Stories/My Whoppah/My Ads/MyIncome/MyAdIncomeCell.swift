//
//  MyAdIncomeCell.swift
//  Whoppah
//
//  Created by Eddie Long on 03/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class MyAdIncomeCell: UITableViewCell {
    static let nibName = "MyAdIncomeCell"
    static let identifier = "MyAdIncomeCell"

    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with ad: MyIncomeCellData) {
        thumbImage.setImage(forUrl: ad.thumbUrl)

        dateLabel.text = ad.date
        priceLabel.text = ad.price
        statusLabel.text = ad.status
        statusLabel.textColor = UIColor(hexString: ad.statusColorHex)
    }
}
