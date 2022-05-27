//
//  BrandSelectionCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AdAttributeSelectionCell: UITableViewCell {
    static let nibName = "AdAttributeSelectionCell"
    static let identifier = "AdAttributeSelectionCell"

    // MARK: - IBOutlets

    private var bag: DisposeBag!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var radio: RadioButton!
    @IBOutlet var checkbox: CheckBox!
    private var allowMultiSelection: Bool = false {
        didSet {
            radio.isVisible = !allowMultiSelection
            checkbox.isVisible = allowMultiSelection
        }
    }

    private var viewModel: AdAttributeCellViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with attribute: AdAttributeCellViewModel) {
        bag = DisposeBag()
        attribute.title.bind(to: nameLabel.rx.text).disposed(by: bag)
        radio.isSelected = attribute.isSelected
        radio.isUserInteractionEnabled = false
        checkbox.isSelected = attribute.isSelected
        checkbox.isUserInteractionEnabled = false
        allowMultiSelection = attribute.allowMulti
        viewModel = attribute
        if let recognizers = gestureRecognizers {
            // Remove existing gestures
            recognizers.filter { $0 as? UITapGestureRecognizer != nil }.forEach { self.removeGestureRecognizer($0) }
        }
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind { _ in
            attribute.onAttributeSelected()
        }.disposed(by: bag)
        addGestureRecognizer(tap)
    }

    override func prepareForReuse() {
        radio.animate = false
        radio.isSelected = false
        radio.animate = true

        checkbox.animate = false
        checkbox.isSelected = false
        checkbox.animate = true
    }
}
