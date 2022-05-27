//
//  MaterialCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/5/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class FilterMaterialCell: UICollectionViewCell {
    // MARK: - Constants

    static let identifier = "FilterMaterialCell"
    static let nibName = "FilterMaterialCell"

    // MARK: - IBOutlets

    @IBOutlet var selectionView: UIView!
    @IBOutlet var nameLabel: UILabel!
    private var attribute: FilterAttribute?
    private var bag: DisposeBag!

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionView.isHidden = true
        selectionView.layer.cornerRadius = selectionView.bounds.height / 2
        updateAppearance()
    }

    func setUp(with attribute: FilterAttribute) {
        bag = DisposeBag()
        self.attribute = attribute
        attribute.title.bind(to: nameLabel.rx.text).disposed(by: bag)
    }

    private func updateAppearance() {
        selectionView.isHidden = !isSelected
        nameLabel.textColor = isSelected ? UIColor.white : UIColor.steel
    }
}
