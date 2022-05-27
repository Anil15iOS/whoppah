//
//  AutocompleteCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/16/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class AutocompleteCell: DDDropDownCell {
    // MARK: - IBOutlets

    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .white
        thumbnailView.layer.cornerRadius = 4.0
        thumbnailView.layer.masksToBounds = true
        thumbnailView.image = R.image.ic_search()
        thumbnailView.tintColor = .silver
        thumbnailView.contentMode = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: -

    /* func configure(with item: AutocompleteItem) {
         optionLabel.text = item.title
         categoryLabel.text = item.subtitle
     //        if item.imageUrl != nil {
     //            thumbnailView.contentMode = .scaleToFill
     //            thumbnailView.kf.setImage(with: item.imageUrl)
     //        } else {
     //            thumbnailView.contentMode = .center
     //            thumbnailView.image = R.image.ic_search()
     //        }
     } */
}
