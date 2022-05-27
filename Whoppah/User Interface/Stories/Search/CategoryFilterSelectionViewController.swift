//
//  CategoryFilterSelectionViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

protocol CategoryFilterSelectionViewControllerDelegate: AnyObject {
    // NOTE: isFinalSelection is true if the VC is not just navigating to/from children categories
    func categoryFilterSelectionViewController(didSelectCategories categories: Set<FilterAttribute>)
}

class CategoryFilterSelectionViewController: UIViewController {
    enum CategoryType {
        case category
        case product
        case productType
    }

    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectAllButton: UIButton!
    lazy var tableHeaderView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.5))
        header.backgroundColor = .silver
        return header
    }()

    weak var delegate: CategoryFilterSelectionViewControllerDelegate?
    var currentSlug: String?
    var categoryType: CategoryType = .category
    var attributes: [FilterAttribute] = []
    var isForceSelectionAvailable: Bool = false
    var selectedCategories = Set<FilterAttribute>()
    var repo: CategoryRepository? {
        didSet {
            loadCategories()
        }
    }

    private var onBackPressed: (() -> Void)?
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)

        switch categoryType {
        case .category:
            navigationBar.titleLabel.text = R.string.localizable.create_ad_select_cat_screen_category()
            subtitleLabel.text = R.string.localizable.create_ad_select_cat_screen_title_category()
        case .product:
            navigationBar.titleLabel.text = R.string.localizable.create_ad_select_cat_screen_product()
            subtitleLabel.text = R.string.localizable.create_ad_select_cat_screen_title_product()
        case .productType:
            navigationBar.titleLabel.text = R.string.localizable.create_ad_select_cat_screen_title_product_type()
            subtitleLabel.text = R.string.localizable.create_ad_select_cat_screen_title_product_type()
        }

        if let currentSlug = currentSlug {
            observedLocalizedString(categoryTitleKey(currentSlug))
                .bind(to: navigationBar.titleLabel.rx.text)
                .disposed(by: bag)
        }
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CategoryFilterSelectionCell.nibName, bundle: nil),
                           forCellReuseIdentifier: CategoryFilterSelectionCell.identifier)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView(frame: .zero)
        selectAllButton.isHidden = attributes.first?.children != nil
        tableView.reloadData()
    }

    private func loadCategories() {
        guard let repo = repo, selectedCategories.isEmpty else { return }
        repo.categories.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let categories = data?.categories.items else { return }
                self.attributes = self.attributes.filter { attribute -> Bool in categories.contains { $0.slug == attribute.slug } }
                if self.isViewLoaded { self.tableView.reloadData() }
            case let .failure(error):
                self.showError(error)
            }
        }).disposed(by: bag)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        onBackPressed?()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveAction(_: UIButton) {
        if selectedCategories.contains(where: { $0.children?.isEmpty != false && attributes.contains($0) }) {
            selectedCategories = selectedCategories.filter { $0.children?.isEmpty != false && attributes.contains($0) }
        }

        delegate?.categoryFilterSelectionViewController(didSelectCategories: selectedCategories)
        dismissAllVCs()
    }

    @IBAction func selectAllAction(_: UIButton) {
        attributes.enumerated().forEach {
            let cell = tableView.cellForRow(at: IndexPath(row: $0.offset, section: 0)) as! CategoryFilterSelectionCell
            cell.checked = true
        }
    }
}

extension CategoryFilterSelectionViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryFilterSelectionCell.identifier) as! CategoryFilterSelectionCell
        let attribute = attributes[indexPath.row]
        let selected = selectedCategories.contains(attribute)
        cell.configure(with: attribute, isSelected: selected)
        let children = attributes[indexPath.row].children
        cell.selectButton.isHidden = !isForceSelectionAvailable || children == nil || children!.isEmpty == true
        cell.delegate = self

        return cell
    }

    private func getRootVC() -> UIViewController? {
        var sourceVC: UIViewController?
        for viewController in navigationController!.viewControllers.reversed() where !(viewController is CategoryFilterSelectionViewController) {
            sourceVC = viewController
            break
        }
        return sourceVC
    }

    private func dismissAllVCs() {
        guard let sourceVC = getRootVC() else { return }
        navigationController?.popToViewController(sourceVC, animated: true)
    }
}

extension CategoryFilterSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = attributes[indexPath.row]

        var childCategory = CategoryType.category
        switch categoryType {
        case .category:
            childCategory = .product
        case .product:
            childCategory = .productType
        case .productType:
            childCategory = .productType
        }

        let cell = tableView.cellForRow(at: indexPath) as! CategoryFilterSelectionCell
        cell.checked = !cell.checked

        if let children = category.children, !children.isEmpty {
            let vc: CategoryFilterSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
            vc.delegate = delegate
            vc.onBackPressed = { [weak self] in self?.selectedCategories = vc.selectedCategories }
            vc.selectedCategories = selectedCategories
            vc.currentSlug = category.slug
            vc.categoryType = childCategory
            vc.attributes = children
            vc.isForceSelectionAvailable = isForceSelectionAvailable
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        44.0
    }
}

extension CategoryFilterSelectionViewController: CategoryFilterSelectionCellDelegate {
    func categoryFilterSelectionCellDidSelect(_ cell: CategoryFilterSelectionCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let category = attributes[indexPath.row]
        addCategory(category: category)
    }

    func categoryFilterSelectionCellDidDeselect(_ cell: CategoryFilterSelectionCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let category = attributes[indexPath.row]
        removeCategory(category: category)
    }

    func categoryFilterSelectionCellDidSelectSection(_ cell: CategoryFilterSelectionCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let category = attributes[indexPath.row]

        selectedCategories.removeAll()
        addCategory(category: category)

        delegate?.categoryFilterSelectionViewController(didSelectCategories: selectedCategories)

        dismissAllVCs()
    }

    private func addCategory(category: FilterAttribute) {
        selectedCategories.insert(category)
    }

    private func removeCategory(category: FilterAttribute) {
        selectedCategories.remove(category)
    }
}
