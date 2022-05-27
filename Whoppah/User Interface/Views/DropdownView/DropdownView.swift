//
//  DropdownView.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/1/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

// MARK: - DropdownViewDelegate

protocol DropdownViewDelegate: AnyObject {
    func dropdownView(_ dropdownView: DropdownView, didSelect item: DropdownItem)
    func dropdownView(_ dropdownView: DropdownView, didDeselect item: DropdownItem)
}

class DropdownView: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    weak var delegate: DropdownViewDelegate?
    var items: [DropdownItem] = [] { didSet { tableView.reloadData() } }
    var allowsMultipleSelection = false { didSet { tableView.allowsMultipleSelection = allowsMultipleSelection } }
    var maximumNumberOfSelectedItems: Int = 3

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("DropdownView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.borderColor = UIColor.silver.cgColor
        contentView.layer.borderWidth = 1.0

        tableView.register(UINib(nibName: DropdownCell.nibName, bundle: nil), forCellReuseIdentifier: DropdownCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func getSelectedItems() -> [Int] {
        if let paths = tableView.indexPathsForSelectedRows {
            return paths.map { $0.row }
        } else if let path = tableView.indexPathForSelectedRow {
            return [path.row]
        }
        return [Int]()
    }
}

// MARK: - UITableViewDataSource

extension DropdownView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as! DropdownCell
        cell.setUp(with: items[indexPath.row])
        cell.checkBox.isHidden = !allowsMultipleSelection
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DropdownView: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        48.0
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if !allowsMultipleSelection { return indexPath }

        var numverOfSelectedItems = 0
        items.forEach { item in
            if item.isSelected {
                numverOfSelectedItems += 1
            }
        }

        return numverOfSelectedItems >= maximumNumberOfSelectedItems ? nil : indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isSelected = true
        let cell = tableView.cellForRow(at: indexPath) as! DropdownCell
        cell.checkBox.isSelected = item.isSelected
        delegate?.dropdownView(self, didSelect: item)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isSelected = false
        let cell = tableView.cellForRow(at: indexPath) as! DropdownCell
        cell.checkBox.isSelected = item.isSelected
        delegate?.dropdownView(self, didDeselect: item)
    }
}
