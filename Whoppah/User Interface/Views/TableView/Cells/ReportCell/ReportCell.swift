//
//  ReportCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {
    static let identifier = "ReportCell"
    static let nibName = "ReportCell"

    // MARK: - IBOutlets

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
}
