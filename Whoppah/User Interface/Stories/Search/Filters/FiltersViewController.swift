//
//  FiltersViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

class FiltersViewController: UIViewController {
    var viewModel: FiltersViewModel!
    private let bag = DisposeBag()

    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(frame: .zero)
        navigationBar.titleLabel.text = "Color"
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(FiltersCell.self, forCellReuseIdentifier: FiltersCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = FiltersCell.estimatedHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    lazy var tableHeaderView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.5))
        header.backgroundColor = .silver
        return header
    }()

    lazy var tableFooterView: FiltersViewFooter = {
        let footer = FiltersViewFooter(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: FiltersViewFooter.estimatedHeight))
        return footer
    }()

    lazy var saveToast: ToastMessage = {
        let toast = ToastMessage(frame: .zero)
        toast.configure(title: R.string.localizable.search_filters_search_saved_toast(), image: R.image.settings_cog_white())
        toast.translatesAutoresizingMaskIntoConstraints = false
        return toast
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .flash
        setupConstraints()
        setupBindings()
        viewModel.load()
    }
}

// MARK: - Bindings

private extension FiltersViewController {
    func setupBindings() {
        setupNavBarBindings()
        setupTableViewBindings()
        setupFooterViewBindings()
        setupSaveBinding()
    }

    func setupNavBarBindings() {
        viewModel.outputs.searchText
            .bind(to: navigationBar.titleLabel.rx.text)
            .disposed(by: bag)

        if navigationController?.topViewController == self {
            navigationBar.backButton.setImage(R.image.ic_close(), for: .normal)
        }

        navigationBar.backButton.rx.tap
            .bind(to: viewModel.inputs.dismiss)
            .disposed(by: bag)
    }

    func setupTableViewBindings() {
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView

        viewModel.outputs.attributes.bind(to: tableView.rx.items(cellIdentifier: FiltersCell.identifier, cellType: FiltersCell.self)) { _, item, cell in
            cell.configure(with: item.title, selected: item.selected, isColor: item.isColor)
        }.disposed(by: bag)

        tableView.rx.modelSelected((title: String, selected: [String], isColor: Bool).self)
            .bind(to: viewModel.inputs.attribute)
            .disposed(by: bag)

        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: bag)
    }

    func setupFooterViewBindings() {
        tableFooterView.filterTapped
            .bind(to: viewModel.inputs.filter)
            .disposed(by: bag)

        viewModel.outputs.filterEnabled
            .bind(to: tableFooterView.filterEnabled)
            .disposed(by: bag)

        tableFooterView.resetTapped
            .bind(to: viewModel.inputs.reset)
            .disposed(by: bag)

        tableFooterView.saveQueryTapped
            .bind(to: viewModel.inputs.save)
            .disposed(by: bag)
    }

    func setupSaveBinding() {
        viewModel.outputs.save
            .map { $0 == .saving }
            .bind(animated: tableFooterView.isAnimating)
            .disposed(by: bag)

        viewModel.outputs.save.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .saved:
                self.saveToast.show(in: self.view)
            case let .error(error):
                self.showError(error)
            default:
                break
            }
        }).disposed(by: bag)
    }
}

// MARK: - Constraints

private extension FiltersViewController {
    func setupConstraints() {
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        view.addSubview(saveToast)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 76),

            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            saveToast.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            saveToast.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            saveToast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveToast.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
}
