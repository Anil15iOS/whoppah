//
//  FilterCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/26/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

protocol FilterCellDelegate: AnyObject {
    func filterCellDidTapDelete(_ cell: FilterCell)
    func filterCellDidSelect(_ cell: FilterCell)
}

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    static let nibName = "FilterCell"

    // MARK: - IBOutlets

    @IBOutlet var singleLabel: UILabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var deleteView: UIImageView!

    private var tap: UITapGestureRecognizer!
    weak var delegate: FilterCellDelegate?

    // MARK: - Nib

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 16.0

        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.layer.borderColor = UIColor.lightOrange.cgColor
        colorView.layer.borderWidth = 1.0

        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAction(_:))))

        tap = UITapGestureRecognizer(target: self, action: #selector(selectAction(_:)))
        tap.isEnabled = false
        addGestureRecognizer(tap)

        backgroundColor = .smoke
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }

    func configure(with filterVM: FilterCellViewModel) {
        switch filterVM.cellType {
        case let .color(hex):
            singleLabel.isHidden = true
            colorView.isHidden = false
            colorView.backgroundColor = UIColor(hexString: hex)
        case let .single(text):
            singleLabel.isHidden = false
            singleLabel.text = text
            colorView.isHidden = true
        }
        switch filterVM.cellStyle {
        case .deletable:
            tap.isEnabled = false
            deleteView.isVisible = true
            backgroundColor = .smoke
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        case .selectable:
            tap.isEnabled = true
            deleteView.isVisible = false
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
        }
    }

    // MARK: - Actions

    @objc func selectAction(_: UITapGestureRecognizer) {
        delegate?.filterCellDidSelect(self)
    }

    @objc func deleteAction(_: UITapGestureRecognizer) {
        delegate?.filterCellDidTapDelete(self)
    }
}
