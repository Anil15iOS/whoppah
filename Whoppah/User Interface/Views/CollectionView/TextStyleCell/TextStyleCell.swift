//
//  TextStyleCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/11/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class TextStyleCell: UICollectionViewCell {
    static let identifier = "TextStyleCell"
    static let nibName = "TextStyleCell"

    private var bag: DisposeBag!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.backgroundColor = UIColor.smoke.cgColor
        layer.masksToBounds = false
        layer.cornerRadius = 16
    }

    func configure(with vm: TextStyleViewModel) {
        bag = DisposeBag()

        vm.text.bind(to: nameLabel.rx.text).disposed(by: bag)
    }
}
