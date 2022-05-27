//
//  ReportDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol ReportDialogDelegate: AnyObject {
    func reportDialogDidSelectUserReport(_ dialog: ReportDialog)
    func reportDialogDidSelectProductReport(_ dialog: ReportDialog)
    func reportDialogDidSelectBlockUser(_ dialog: ReportDialog)
}

class ReportDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - Properties

    weak var delegate: ReportDialogDelegate?
    var items = [
        R.string.localizable.ad_details_report_user(),
        R.string.localizable.ad_details_report_product()
    ]

    var reportUser: Bool = true {
        didSet {
            if !reportUser {
                items.removeAll(where: { $0 == R.string.localizable.ad_details_report_user() })
            }
        }
    }

    var reportProduct: Bool = true {
        didSet {
            if !reportProduct {
                items.removeAll(where: { $0 == R.string.localizable.ad_details_report_product() })
            }
        }
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        titleLabel.text = titleLabel.text?.uppercased()
    }

    // MARK: -

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ReportCell.nibName, bundle: nil), forCellReuseIdentifier: ReportCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension ReportDialog: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.identifier) as! ReportCell
        cell.nameLabel.text = items[indexPath.row]
        cell.iconView.image = indexPath.row == 2 ? R.image.ic_block_24px() : R.image.ic_report_problem_24px()
        return cell
    }
}

// MARK: -

extension ReportDialog: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            delegate?.reportDialogDidSelectUserReport(self)
        case 1:
            delegate?.reportDialogDidSelectProductReport(self)
        case 2:
            delegate?.reportDialogDidSelectBlockUser(self)
        default:
            break
        }
    }
}
