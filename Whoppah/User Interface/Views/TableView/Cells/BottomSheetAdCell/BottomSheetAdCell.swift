//
//  BottomSheetAdCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/26/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class BottomSheetAdCell: UITableViewCell {
    static let identifier = "BottomSheetAdCell"
    static let nibName = "BottomSheetAdCell"

    // MARK: - IBOutlets

    @IBOutlet var adImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var bidLabel: UILabel!
    @IBOutlet var bidNowLabel: UILabel!

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        adImageView.layer.cornerRadius = 4.0
        adImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: -

    func configure(with ad: AdViewModel, bag _: DisposeBag) {
        nameLabel.text = ad.title
        // REMOVED so we don't need to pull in all brands for products
        // brandLabel.text = ad.brand
        adImageView.setImage(forUrl: ad.thumbnail?.asURL())

        /* ad.maxBidText.subscribe(onNext: { [weak self] (text) in
             guard let self = self else { return }
             if let text = text {
                 self.bidLabel.isHidden = false
             	self.bidLabel.text = R.string.localizable.search_map_highest_bid(text)
                 self.bidNowLabel.isHidden = true
             } else {
                 self.bidLabel.text = R.string.localizable.search_map_no_bid_yet()
                 self.bidLabel.isHidden = true
             	self.bidNowLabel.text = self.bidNowLabel.text?.uppercased()
                 self.bidNowLabel.isHidden = false
             }
         }).disposed(by: bag) */
    }
}
