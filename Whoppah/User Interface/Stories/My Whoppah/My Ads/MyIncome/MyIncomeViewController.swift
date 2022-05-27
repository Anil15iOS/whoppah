//
//  MyIncomeViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCoreNext
import Resolver

class MyIncomeViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var tableView: UITableView!

    var viewModel: MyIncomeViewModel!
    private let bag = DisposeBag()
    
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setupTableView()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.my_ads_sold_screen_title()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.register(UINib(nibName: MyAdIncomeCell.nibName, bundle: nil), forCellReuseIdentifier: MyAdIncomeCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        tableView.separatorInsetReference = .fromAutomaticInsets

        tableView.bindHeadRefreshHandler({
            self.refetchAds()
        }, themeColor: UIColor.orange, refreshStyle: .native)
        tableView.bindFootRefreshHandler(nil, themeColor: UIColor.orange, refreshStyle: .native)

        viewModel.outputs.ads.bind(to: tableView.rx.items(cellIdentifier: MyAdIncomeCell.identifier, cellType: MyAdIncomeCell.self)) { [weak self] _, data, cell in
            guard let self = self else { return }
            cell.configure(with: data)
            self.tableView.hideRefreshControls(self.viewModel.itemsPager)
        }.disposed(by: bag)

        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(MyIncomeCellData.self))
            .bind { [weak self] indexPath, model in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let navigationVC = UINavigationController()
                navigationVC.isNavigationBarHidden = true
                navigationVC.isModalInPresentation = true
                if UIDevice.current.userInterfaceIdiom != .pad { navigationVC.modalPresentationStyle = .fullScreen }
                let coordinator = AdDetailsCoordinator(navigationController: navigationVC)
                coordinator.start(adID: model.ID)
                self.present(navigationVC, animated: true, completion: nil)
            }.disposed(by: bag)

        tableView.tableFooterView = UIView(frame: .zero) // Remove extraneous tableview separators
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        if let navVC = navigationController {
            navVC.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func refetchAds() {
        viewModel.loadItems()
    }

    private func loadMoreAds() {
        guard viewModel.loadMoreItems() else {
            tableView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
            return
        }
        tableView.showFooterRefreshControl()
    }
}

extension MyIncomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        89
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNumberOfItems() - 5 {
            DispatchQueue.main.async {
                self.loadMoreAds()
            }
        }
    }
}
