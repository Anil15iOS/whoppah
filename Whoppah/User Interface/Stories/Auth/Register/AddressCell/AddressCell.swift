//
//  AddressCell.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/13/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol AddressCellDelegate: AnyObject {
    func addressCellDidTapEditButton(_ cell: AddressCell)
    func addressCellDidTapDeleteButton(_ cell: AddressCell)
}

class AddressCell: UITableViewCell {
    static let identifier = "AddressCell"
    static let nibName = "AddressCell"

    // MARK: - IBOutlets

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var postcodeCityLabel: UILabel!
    @IBOutlet var editButton: RoundedButton!
    @IBOutlet var deleteButton: RoundedButton!

    weak var delegate: AddressCellDelegate?
    private var vm: AddressCellViewModel?
    private var bag: DisposeBag!

    // MARK: - Nib

    func configure(with address: LegacyAddressInput) {
        addressLabel.text = address.line1
        postcodeCityLabel.text = address.postalCode + " " + address.city
    }

    func configure(with vm: AddressCellViewModel) {
        bag = DisposeBag()
        self.vm = vm
        addressLabel.text = vm.addressText
        postcodeCityLabel.text = vm.postCodeCityText
        vm.canDelete.subscribe(onNext: { [weak self] delete in
            self?.deleteButton.isVisible = delete
        }).disposed(by: bag)
    }

    // MARK: - Actions

    @IBAction func editAction(_: UIButton) {
        if let vm = vm {
            vm.editAddress()
        } else {
            delegate?.addressCellDidTapEditButton(self)
        }
    }

    @IBAction func deleteButton(_: UIButton) {
        if let vm = vm {
            vm.deleteAddress()
        } else {
            delegate?.addressCellDidTapDeleteButton(self)
        }
    }
}
