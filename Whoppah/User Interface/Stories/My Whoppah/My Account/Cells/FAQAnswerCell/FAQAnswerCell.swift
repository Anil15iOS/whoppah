//
//  FAQAnswerCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/28/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
class FAQAnswerCell: UITableViewCell {
    static let nibName = "FAQAnswerCell"
    static let identifier = "FAQAnswerCell"

    @IBOutlet var answerLabel: UILabel!
    var itemText: String = ""
    private var bag: DisposeBag!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with block: TextBlock) {
        bag = DisposeBag()
        observedLocalizedString(block.descriptionKey)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] localizedText in
                guard let self = self else { return }
                self.itemText = localizedText ?? ""
                self.answerLabel.attributedText = self.itemText.htmlAttributed(family: UIFont.bodyText.familyName, size: 10.0, color: UIColor.space)
            }).disposed(by: bag)
    }
}
