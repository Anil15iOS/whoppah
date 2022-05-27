//
//  FilterItemSelectionViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class FilterItemSelectionViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!
    lazy var tableHeaderView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.5))
        header.backgroundColor = .silver
        return header
    }()

    var viewModel: FilterItemSelectionViewModel!
    private let bag = DisposeBag()

    var onSelectionCompleted: (([FilterAttribute]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
        setUpSearchBar()
        setUpButtons()
        setupViewModel()
    }
}

// MARK: - Private

private extension FilterItemSelectionViewController {
    func setUpNavigationBar() {
        viewModel.outputs.title.bind(to: navigationBar.titleLabel.rx.text).disposed(by: bag)
        viewModel.outputs.subtitle.bind(to: subtitleLabel.rx.text).disposed(by: bag)
        navigationBar.backButton.rx.tap.bind {
            self.viewModel.dismiss()
        }.disposed(by: bag)
    }

    func setupViewModel() {
        _ = viewModel.outputs.isLoading.drive(onNext: { [weak self] loading in
            loading ? self?.showLoading() : self?.hideLoading()
        }).disposed(by: bag)
    }

    func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = tableHeaderView
        tableView.register(UINib(nibName: FilterItemSelectionCell.nibName, bundle: nil), forCellReuseIdentifier: FilterItemSelectionCell.identifier)

        viewModel.outputs.filterCells.bind(to: tableView.rx.items(cellIdentifier: FilterItemSelectionCell.identifier, cellType: FilterItemSelectionCell.self)) { _, item, cell in
            cell.configure(with: item)
        }.disposed(by: bag)

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(FilterItemCellViewModel.self))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] path, model in
                guard let self = self else { return }
                model.isSelected = !model.isSelected
                self.tableView.deselectRow(at: path, animated: true)
            }).disposed(by: bag)
    }

    func setUpSearchBar() {
        viewModel.outputs.placeholder
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] placeholder in
                guard let self = self else { return }
                self.searchBar.placeholder = placeholder
            }).disposed(by: bag)

        viewModel.outputs.searchBarHidden.subscribe(onNext: { [weak self] isHidden in
            guard let self = self, isHidden else { return }
            self.searchBar.removeFromSuperview()
        }).disposed(by: bag)

        searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputs.search)
            .disposed(by: bag)

        searchBar.rx.searchButtonClicked.bind { [unowned self] _ in
            self.searchBar.resignFirstResponder()
        }.disposed(by: bag)
    }

    func setUpButtons() {
        saveButton.style = .primary
        saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if let filters = try? self.viewModel.outputs.selectedFilterItems.value() {
                self.onSelectionCompleted?(filters)
                self.viewModel.dismiss()
            }
        }.disposed(by: bag)
        viewModel.outputs.selectedFilterItems.map { !$0.isEmpty }.bind(to: saveButton.rx.isEnabled).disposed(by: bag)
    }

    func showLoading() {
        loadingViewContainer.isVisible = true
        loadingView.startAnimating()
    }

    func hideLoading() {
        loadingViewContainer.isVisible = false
        loadingView.stopAnimating()
    }
}
