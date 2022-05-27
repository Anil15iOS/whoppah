//
//  BrandSelectionCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/10/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class FilterItemSelectionCell: UITableViewCell {
    static let nibName = "FilterItemSelectionCell"
    static let identifier = "FilterItemSelectionCell"

    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var radio: RadioButton!
    @IBOutlet var checkbox: CheckBox!

    private var viewModel: FilterItemCellViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with vm: FilterItemCellViewModel) {
        vm.title.bind(to: nameLabel.rx.text).disposed(by: vm.bag)
        vm.itemClick.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.radio.isSelected = vm.isSelected
            self.checkbox.isSelected = vm.isSelected
        }).disposed(by: vm.bag)
        radio.isSelected = vm.isSelected
        checkbox.isSelected = vm.isSelected
        switch vm.selectionStyle {
        case .checkbox:
            radio.isVisible = false
            checkbox.isVisible = true
        case .radio:
            checkbox.isVisible = false
            radio.isVisible = true
        }
        radio.delegate = self
        checkbox.delegate = self
        viewModel = vm
    }

    override func prepareForReuse() {
        radio.animate = false
        radio.isSelected = viewModel?.isSelected ?? false
        radio.animate = true
        checkbox.animate = false
        checkbox.isSelected = viewModel?.isSelected ?? false
        checkbox.animate = true
    }
}

extension FilterItemSelectionCell: RadioButtonDelegate {
    func radioButtonDidChangeState(_: RadioButton) {
        guard let vm = viewModel else { return }
        vm.isSelected = !vm.isSelected
    }
}

extension FilterItemSelectionCell: CheckBoxDelegate {
    func checkBoxDidChangeState(_: CheckBox) {
        guard let vm = viewModel else { return }
        vm.isSelected = !vm.isSelected
    }
}
