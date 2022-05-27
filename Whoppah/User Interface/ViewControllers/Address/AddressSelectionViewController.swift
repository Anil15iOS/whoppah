//
//  AddressSelectionViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 28/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver

class AddressSelectionViewController: UIViewController {
    @IBOutlet var addressesTableView: UITableView!
    @IBOutlet var addressesHeight: NSLayoutConstraint!

    // MARK: Private

    private var locations: [LegacyAddress] = []
    var selectedItem: UUID?

    var viewModel: AddressSelectionViewModel!
    private let bag = DisposeBag()
    
    @Injected fileprivate var crashReporter: CrashReporter
    @Injected fileprivate var user: WhoppahCore.LegacyUserService
    @Injected fileprivate var merchant: MerchantService

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()

        loadData()
    }

    private func setUpTableView() {
        addressesTableView.delegate = self
        addressesTableView.register(UINib(nibName: DeliveryCell.nibName, bundle: nil), forCellReuseIdentifier: DeliveryCell.identifier)
    }

    func loadData() {
        viewModel.outputs.addresses.bind(to: addressesTableView.rx.items(cellIdentifier: DeliveryCell.identifier, cellType: DeliveryCell.self)) { [weak self] _, item, cell in
            guard let self = self else { return }
            cell.configure(with: item, bag: self.bag)
        }.disposed(by: bag)

        Observable.zip(addressesTableView.rx.itemSelected, addressesTableView.rx.modelSelected(DeliveryCellViewModel.self))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] path, model in
                guard let self = self else { return }
                self.viewModel.onAddressSelected(path, model: model)
                self.addressesTableView.deselectRow(at: path, animated: true)
            }).disposed(by: bag)

        viewModel.outputs.addresses
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }
                self.addressesHeight.constant = CGFloat(results.count) * 60.0
            }).disposed(by: bag)
    }

    // MARK: Actions

    @IBAction func addAddressAction(_: UIButton) {
        let addressVC = AddEditAddressViewController()
        addressVC.delegate = self
        addressVC.isDeleteButtonHidden = true
        navigationController?.pushViewController(addressVC, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension AddressSelectionViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - AddEditAddressViewControllerDelegate

extension AddressSelectionViewController: AddEditAddressViewControllerDelegate {
    func addEditAddressViewController(didDelete _: LegacyAddressInput) {}

    func addEditAddressViewController(didSave address: LegacyAddressInput) {
        guard address.id == nil else { return }

        guard let id = user.current?.merchantId else { return }
        merchant.addAddress(id: id, address: address)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] address in
                guard let self = self else { return }
                self.locations.append(address)
                self.addressesTableView.reloadData()
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error)
            }).disposed(by: bag)
    }
}
