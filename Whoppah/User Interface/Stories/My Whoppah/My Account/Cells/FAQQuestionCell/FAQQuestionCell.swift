//
//  FAQQuestionCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/28/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import ExpandableCell
import RxSwift
import UIKit
import WhoppahCore

class FAQQuestionCell: ExpandableCell {
    enum State {
        case normal
        case expanded
    }

    static let nibName = "FAQQuestionCell"
    static let identifier = "FAQQuestionCell"

    // MARK: - IBOutlets

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var arrowIcon: UIImageView!
    private var bag: DisposeBag!
    var itemText: String = ""
    var titleKey: String = ""

    // MARK: - Properties

    var state: State = .normal { didSet { updateAppearanceAnimated() } }

    override func awakeFromNib() {
        super.awakeFromNib()

        updateAppearance()
        arrowImageView.removeFromSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with block: TextBlock) {
        bag = DisposeBag()
        titleKey = block.titleKey
        observedLocalizedString(block.titleKey)
            .subscribe(onNext: { [weak self] localizedText in
                guard let self = self else { return }
                self.itemText = localizedText ?? ""
                self.questionLabel.text = self.itemText
            }).disposed(by: bag)
    }

    // MARK: - Appearance

    private func updateAppearanceAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.updateAppearance()
        }
    }

    private func updateAppearance() {
        switch state {
        case .normal:
            arrowIcon.image = R.image.ic_arrow_down()
        case .expanded:
            arrowIcon.image = R.image.ic_arrow_up()
        }
    }
}
