//
//  StylesSelectionViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol StylesSelectionViewControllerDelegate: AnyObject {
    func stylesSelectionViewController(_ viewController: StylesSelectionViewController, didSelect styles: [AdAttribute])
}

class StylesSelectionViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet var maxSelectionLabel: UILabel!
    @IBOutlet var numberStylesLabel: UILabel!
    @IBOutlet var tableViewTopInset: NSLayoutConstraint!
    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!

    private var repo: AdAttributeRepository!

    weak var delegate: StylesSelectionViewControllerDelegate?
    var styles: [Style] = []
    var selectedStyles: [AdAttribute] = []
    var maxSelection = ProductConfig.maxNumberStyles
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRepo()
        setUpNavigationBar()
        setUpTableView()
        setUpButtons()
        loadStyles()
    }

    // MARK: - Private

    private func setUpRepo() {
        repo = RepositoryFactory.createAdAttributeRepo(type: .styles)
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.create_ad_select_style_screen_title()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: StyleSelectionCell.nibName, bundle: nil), forCellReuseIdentifier: StyleSelectionCell.identifier)

        maxSelectionLabel.text = R.string.localizable.create_ad_select_style_screen_max_styles_title(maxSelection)
        maxSelectionLabel.isHidden = maxSelection == 0
        numberStylesLabel.isHidden = maxSelectionLabel.isHidden
        tableViewTopInset.constant = maxSelection == 0 ? 0.0 : 46.0
        updateNumSelectedText()
    }

    private func setUpButtons() {
        saveButton.style = .primary
    }

    private func updateNumSelectedText() {
        numberStylesLabel.text = "\(selectedStyles.count) / \(maxSelection)"
        if selectedStyles.count == maxSelection {
            numberStylesLabel.textColor = .greenValidation
        } else {
            numberStylesLabel.textColor = .steel
        }
    }

    private func loadStyles() {
        showLoading()

        repo.loadAttributes()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (styles: [Style]) in
                guard let self = self else { return }
                self.hideLoading()
                self.styles = styles
                self.tableView.reloadData()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showError(error)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: bag)
        tableView.reloadData()
    }

    fileprivate func showLoading() {
        loadingViewContainer.isVisible = true
        loadingView.startAnimating()
    }

    fileprivate func hideLoading() {
        loadingViewContainer.isVisible = false
        loadingView.stopAnimating()
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveAction(_: PrimaryLargeButton) {
        delegate?.stylesSelectionViewController(self, didSelect: selectedStyles)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StylesSelectionViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        styles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StyleSelectionCell.identifier) as! StyleSelectionCell
        cell.configure(with: styles[indexPath.row])
        cell.checkBox.isSelected = !selectedStyles.filter { $0.id == styles[indexPath.row].id }.isEmpty
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StylesSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard maxSelection > 0 else { return indexPath }
        let cell = tableView.cellForRow(at: indexPath) as! StyleSelectionCell
        return selectedStyles.count < maxSelection || cell.checkBox.isSelected ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StyleSelectionCell

        if cell.checkBox.isSelected {
            selectedStyles.removeAll(where: { $0.id == styles[indexPath.row].id })
        } else {
            let style = styles[indexPath.row]
            selectedStyles.append(AdAttributeInput(id: style.id, title: style.title, slug: style.slug, description: style.description))
        }

        cell.checkBox.isSelected = !cell.checkBox.isSelected

        updateNumSelectedText()
        saveButton.isEnabled = !selectedStyles.isEmpty
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }
}
