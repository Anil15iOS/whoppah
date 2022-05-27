//
//  AdAttributeSelectionViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol AdAttributeSelectionViewControllerDelegate: AnyObject {
    func adAttributeSelectionViewController(didSelect attributes: [AdAttribute], ofType type: AttributeType)
}

class AdAttributeSelectionViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var viewTitle: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet var suggestionView: UIView!
    @IBOutlet var unknownSwitchLabel: UILabel!
    @IBOutlet var suggestionTitle: UILabel!
    @IBOutlet var suggestionDescription: UILabel!
    @IBOutlet var suggestionTextfield: WPTextField!
    @IBOutlet var unknownView: UIView!
    @IBOutlet var unknownSwitch: UISwitch!

    weak var delegate: AdAttributeSelectionViewControllerDelegate?
    var viewModel: AdAttributeSelectionViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpTableView()
        setUpTextField()
        setUpButtons()
        setUpLabels()
        loadAttributes()
        setupViewModel()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        setNavBar(title: "", enabled: true, transparent: false)

        if navigationController?.viewControllers.count == 1 {
            addCloseButton(image: R.image.ic_close()).rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.dismiss()
            }.disposed(by: bag)
        }
    }

    private func setupViewModel() {
        _ = viewModel.isLoading.drive(onNext: { [weak self] loading in
            guard let self = self else { return }
            if loading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        })
            .disposed(by: bag)

        viewModel.outputs.showUnknownView.bind(to: unknownView.rx.isVisible).disposed(by: bag)
        viewModel.outputs.isUnknown.bind(to: unknownSwitch.rx.isOn).disposed(by: bag)
        // Switch always sends the initial state to the VM - we don't want that
        unknownSwitch.rx.isOn.skip(1).bind(to: viewModel.inputs.isUnknown).disposed(by: bag)
        viewModel.outputs.showSuggestionView.bind(to: suggestionView.rx.isVisible).disposed(by: bag)
    }

    private func setUpLabels() {
        viewModel.outputs.unknownSwitchLabel.bind(to: unknownSwitchLabel.rx.text).disposed(by: bag)
        viewModel.outputs.saveButtonText.bind(to: saveButton.rx.title(for: .normal)).disposed(by: bag)
        viewModel.outputs.viewTitle.bind(to: viewTitle.rx.text).disposed(by: bag)
        viewModel.outputs.title.bind(to: rx.title).disposed(by: bag)

        viewModel.outputs.suggestionTitle.bind(to: suggestionTitle.rx.text).disposed(by: bag)
        viewModel.outputs.suggestionDescription.bind(to: suggestionDescription.rx.text).disposed(by: bag)
        viewModel.outputs.suggestionPlaceholder.compactMap { $0 }.bind(to: suggestionTextfield.rx.placeholder).disposed(by: bag)
    }

    private func setUpTableView() {
        // tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        // Stop grouped section titles from having grey background
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.register(UINib(nibName: AdAttributeSelectionCell.nibName, bundle: nil), forCellReuseIdentifier: AdAttributeSelectionCell.identifier)
        let dummyViewHeight = CGFloat(56)
        // To stop headers from sticking to the top of the table view
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)

        viewModel.attributeCells.bind(to: tableView.rx.items(cellIdentifier: AdAttributeSelectionCell.identifier, cellType: AdAttributeSelectionCell.self)) { _, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: bag)
    }

    private func setUpTextField() {
        let image = UIImageView(image: R.image.searchIconGray())
        image.contentMode = .center
        image.setWidthAnchor(24)
        image.setAspect(0.91)
        searchTextField.leftView = image
        searchTextField.leftViewMode = .always
        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = 0
        searchTextField.layer.cornerRadius = 5
        searchTextField.backgroundColor = UIColor(hexString: "#767680", alpha: 0.12)
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.createAdSelectAttributeSearchPlaceholder(),
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3C3C43", alpha: 0.6)])
        viewModel.outputs.suggestion.bind(to: suggestionTextfield.rx.text).disposed(by: bag)
        suggestionTextfield.rx.text.orEmpty.bind(to: viewModel.inputs.suggestion).disposed(by: bag)
    }

    private func setUpButtons() {
        saveButton.style = .shinyBlue
    }

    private func loadAttributes() {
        viewModel.loadAttributes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.tableView.reloadData()
            case let .failure(error):
                self.showError(error)
                self.viewModel.dismiss()
            }
        }
    }

    fileprivate func showLoading() {
        loadingViewContainer.isVisible = true
        loadingView.startAnimating()
    }

    fileprivate func hideLoading() {
        loadingViewContainer.isVisible = false
        loadingView.stopAnimating()
    }

    @IBAction func saveAction(_: PrimaryLargeButton) {
        viewModel.save { attributes, type in
            self.delegate?.adAttributeSelectionViewController(didSelect: attributes, ofType: type)
        }
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text!
        viewModel.onFilterTextChanged(currentText)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

/* extension AdAttributeSelectionViewController: UITableViewDataSource {

 func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return viewModel.sectionTitle(section: section)
 }

 } */

// MARK: - UITableViewDelegate

extension AdAttributeSelectionViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let text = viewModel.sectionTitle(section: section)
        guard !text.isEmpty else { return 0 }
        return 48
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text = viewModel.sectionTitle(section: section)
        guard !text.isEmpty else { return nil }

        // Add title
        let height: CGFloat = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        headerView.backgroundColor = .clear
        let label = UILabel()
        label.frame = CGRect(x: 16, y: height - 32, width: headerView.frame.width - 32, height: 24)
        label.text = text
        label.font = UIFont.subtitle
        label.textColor = .steel
        label.backgroundColor = .clear

        headerView.addSubview(label)

        // Add separator at the bottom
        let separator = UIView(frame: CGRect(x: 0, y: height - 0.5, width: tableView.frame.width, height: 0.5))
        separator.backgroundColor = .smoke
        headerView.addSubview(separator)

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let text = viewModel.sectionTitle(section: section)
        guard !text.isEmpty else { return nil }

        let result = UIView()

        // recreate insets from existing ones in the table view
        let insets = tableView.separatorInset
        let width = tableView.bounds.width - insets.left - insets.right
        let sepFrame = CGRect(x: insets.left, y: -0.5, width: width, height: 0.5)

        // create layer with separator, setting color
        let sep = CALayer()
        sep.frame = sepFrame
        sep.backgroundColor = UIColor.smoke.cgColor
        result.layer.addSublayer(sep)

        return result
    }
}
