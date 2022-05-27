//
//  ExpandableCategoryMenuCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class ExpandableCategoryMenuCell: UITableViewCell {
    static let identifier = "ExpandableCategoryMenuCell"

    enum State {
        case normal
        case expanded
    }

    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var expandedLabel: UILabel!
    @IBOutlet var arrowIcon: UIImageView!

    private var bag: DisposeBag!

    // MARK: - Properties

    private var _state: State = .normal
    var state: State {
        get {
            _state
        }
        
        set {
            _state = newValue
            updateAppearanceAnimated()
        }
    }

    var category: WhoppahCore.Category?
    typealias SectionTapped = (WhoppahCore.Category?) -> Void
    var onSectionTapped: SectionTapped?

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()
        updateAppearance()
        backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandedLabelTapped))
        tap.cancelsTouchesInView = true
        expandedLabel.isUserInteractionEnabled = false
        expandedLabel.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with category: WhoppahCore.Category, isExpanded: Bool) {
        bag = DisposeBag()
        self.category = category
        observedLocalizedString(category.title)
            .compactMap { $0?.capitalizingFirstLetter(false) }
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
        // Set internal directly as we do not want the delay that happens with the setter animation
        _state = isExpanded ? .expanded : .normal
        updateAppearance()
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
            expandedLabel.alpha = 0.0
            arrowIcon.image = R.image.ic_arrow_down()
            expandedLabel.isUserInteractionEnabled = false
            backgroundColor = .white
        case .expanded:
            expandedLabel.alpha = 1.0
            arrowIcon.image = R.image.ic_arrow_up()
            expandedLabel.isUserInteractionEnabled = true
            backgroundColor = .flash
        }
    }

    @objc func expandedLabelTapped(_: UITapGestureRecognizer) {
        onSectionTapped?(category)
    }
}
