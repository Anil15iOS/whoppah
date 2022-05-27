//
//  SortByDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 4/9/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

protocol SortByDialogDelegate: AnyObject {
    func sortByDialog(_ dialog: SortByDialog, didSelectOrder order: GraphQL.Ordering?, sortType type: GraphQL.SearchSort?)
}

class SortByDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    private var sorts: [String] = [
        R.string.localizable.search_sort_default(),
        R.string.localizable.search_sort_price_lowest_first(),
        R.string.localizable.search_sort_price_highest_first(),
        R.string.localizable.search_sort_distance_close_first(),
        R.string.localizable.search_sort_distance_far_first(),
        R.string.localizable.search_sort_date_newest_first(),
        R.string.localizable.search_sort_date_oldest_first()
    ]
    var selectedSortOrder: GraphQL.Ordering?
    var selectedSortType: GraphQL.SearchSort?

    private var selectedIndexPath: IndexPath!
    weak var delegate: SortByDialogDelegate?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        updateSelectedSortBy()
        onComplete = {
            self.delegate?.sortByDialog(self, didSelectOrder: self.selectedSortOrder, sortType: self.selectedSortType)
        }
    }

    // MARK: - Private

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: SortByCell.nibName, bundle: nil), forCellReuseIdentifier: SortByCell.identifier)
    }

    private func updateSelectedSortBy() {
        switch (selectedSortOrder, selectedSortType) {
        case let (sort, type) where type == .price:
            selectedIndexPath = IndexPath(row: sort == .asc ? 1 : 2, section: 0)
        case let (sort, type) where type == .distance:
            selectedIndexPath = IndexPath(row: sort == .asc ? 3 : 4, section: 0)
        case let (sort, type) where type == .created:
            selectedIndexPath = IndexPath(row: sort == .asc ? 6 : 5, section: 0)
        default:
            selectedIndexPath = IndexPath(row: 0, section: 0)
        }

        tableView.reloadData()
    }

    // MARK: - Actions
}

// MARK: - UITableViewDataSource

extension SortByDialog: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        sorts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier) as! SortByCell
        cell.nameLabel.text = sorts[indexPath.row]
        cell.radioButton.isSelected = indexPath.row == selectedIndexPath.row
        return cell
    }
}

// MARK: -

extension SortByDialog: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let oldCell = tableView.cellForRow(at: selectedIndexPath!) as! SortByCell
        oldCell.radioButton.isSelected = false

        let newCell = tableView.cellForRow(at: indexPath) as! SortByCell
        newCell.radioButton.isSelected = true
        selectedIndexPath = indexPath

        switch indexPath.row {
        case 0:
            selectedSortOrder = nil
            selectedSortType = nil
        case 1:
            selectedSortOrder = .asc
            selectedSortType = .price
        case 2:
            selectedSortOrder = .desc
            selectedSortType = .price
        case 3:
            selectedSortOrder = .asc
            selectedSortType = .distance
        case 4:
            selectedSortOrder = .desc
            selectedSortType = .distance
        case 5:
            selectedSortOrder = .desc
            selectedSortType = .created
        case 6:
            selectedSortOrder = .asc
            selectedSortType = .created
        default:
            break
        }

        dismiss()
    }
}
