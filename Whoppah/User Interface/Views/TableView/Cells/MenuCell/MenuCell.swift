//
//  MenuCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    static let nibName = "MenuCell"
    static let identifier = "MenuCell"

    // MARK: - IBOutlets

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var disclosureIcon: UIImageView!
    @IBOutlet var loadingView: UIImageView!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .flash
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with item: MenuItem) {
        iconView.image = item.icon
        iconView.isHidden = item.icon == nil
        titleLabel.text = item.title
    }

    func toggleLoading(_ enable: Bool) {
        loadingView.isVisible = enable
        if enable {
            loadingView.showLoading()
        } else {
            loadingView.hideLoading()
        }
        disclosureIcon.isVisible = !enable
    }
}
