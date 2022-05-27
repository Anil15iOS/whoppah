//
//  CategorySelectionCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol CategoryFilterSelectionCellDelegate: AnyObject {
    func categoryFilterSelectionCellDidSelect(_ cell: CategoryFilterSelectionCell)
    func categoryFilterSelectionCellDidSelectSection(_ cell: CategoryFilterSelectionCell)
    func categoryFilterSelectionCellDidDeselect(_ cell: CategoryFilterSelectionCell)
}

class CategoryFilterSelectionCell: UITableViewCell {
    static let nibName = "CategoryFilterSelectionCell"
    static let identifier = "CategoryFilterSelectionCell"

    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var disclosureIcon: UIImageView!
    @IBOutlet var checkbox: CheckBox!
    @IBOutlet var selectButton: UIButton!
    var checked: Bool = false {
        didSet {
            guard checkbox.isVisible else { return }
            checkbox.isSelected = checked
            if checked {
                delegate?.categoryFilterSelectionCellDidSelect(self)
            } else {
                delegate?.categoryFilterSelectionCellDidDeselect(self)
            }
        }
    }

    private var bag: DisposeBag!
    weak var delegate: CategoryFilterSelectionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none

        checkbox.isUserInteractionEnabled = false
    }

    func configure(with attribute: FilterAttribute, isSelected: Bool) {
        bag = DisposeBag()
        attribute.title.bind(to: nameLabel.rx.text).disposed(by: bag)
        disclosureIcon.isHidden = attribute.children == nil || attribute.children!.isEmpty
        checkbox.isHidden = !disclosureIcon.isHidden
        checkbox.isSelected = isSelected
    }

    @IBAction func selectPressed(_: UIButton) {
        delegate?.categoryFilterSelectionCellDidSelectSection(self)
    }
}
