//
//  DeliveryCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/4/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class DeliveryCell: UITableViewCell {
    static let identifier = "DeliveryCell"
    static let nibName = "DeliveryCell"

    @IBOutlet var radioButton: RadioButton!
    @IBOutlet var addressLine1Label: UILabel!
    @IBOutlet var addressRemainingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        radioButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with vm: DeliveryCellViewModel, bag: DisposeBag, selected: Bool = false) {
        addressLine1Label.text = vm.addressLine1
        addressRemainingLabel.text = vm.addressLine2
        addressRemainingLabel.isHidden = vm.addressLine2.isEmpty
        radioButton.isSelected = selected

        vm.selected.subscribe(onNext: { [weak self] selected in
            guard let self = self else { return }
            self.radioButton.isSelected = selected
        }).disposed(by: bag)
    }
}
