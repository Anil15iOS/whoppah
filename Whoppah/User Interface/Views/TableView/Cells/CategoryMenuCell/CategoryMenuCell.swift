//
//  CategoryMenuCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class CategoryMenuCell: UITableViewCell {
    static let identifier = "CategoryMenuCell"

    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!

    var category: WhoppahCore.Category?
    private var bag: DisposeBag!

    override func awakeFromNib() {
        super.awakeFromNib()
        // backgroundColor = .flash
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with category: WhoppahCore.Category) {
        self.category = category
        bag = DisposeBag()
        observedLocalizedString(category.title).compactMap { $0?.capitalizingFirstLetter(false) }
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
    }
}
