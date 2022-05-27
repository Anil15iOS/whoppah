//
//  ReportUserDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

class ReportUserDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var reasonTextField: WPTextField!
    @IBOutlet var commentTextField: WPTextField!
    @IBOutlet var sendButton: PrimaryLargeButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var reasonStackView: UIStackView!

    // MARK: Properties

    private var merchantId: UUID
    private var reasonDropdownView: DropdownView!
    private var selectedReason = DropdownOption.violatingContent
    var reasonHeight: NSLayoutConstraint!
    var isReasonOpened: Bool = false
    var sendCallback: ((UUID, GraphQL.AbuseReportReason, String) -> Void)?

    enum DropdownOption: String, CaseIterable {
        case violatingContent = "violated"
        case spam = "spam"
        case wrongCategory = "wrong_category"
        case poorPhotoQuality = "poor_photo"
    }

    let reasonMap: [DropdownOption: GraphQL.AbuseReportReason] = [
        .violatingContent: GraphQL.AbuseReportReason.violatingContent,
        .spam: GraphQL.AbuseReportReason.spam,
        .wrongCategory: GraphQL.AbuseReportReason.wrongCategory,
        .poorPhotoQuality: GraphQL.AbuseReportReason.poorPhotoQuality
    ]

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDropdown()
        setUpTextFields()
        sendButton.style = .primary
    }

    // MARK: - Initialization

    init(merchantId: UUID) {
        self.merchantId = merchantId
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("Not implemented")
    }

    private func setUpDropdown() {
        reasonDropdownView = DropdownView()
        reasonDropdownView.delegate = self
        reasonDropdownView.allowsMultipleSelection = false
        reasonHeight = reasonDropdownView.heightAnchor.constraint(equalToConstant: 48.0)
        reasonHeight.isActive = true
        reasonDropdownView.isHidden = true
        reasonStackView.addArrangedSubview(reasonDropdownView)

        var items = [DropdownItem]()
        items.append(DropdownItem(ID: DropdownOption.violatingContent.rawValue, name: R.string.localizable.report_user_inappropriate_content()))
        items.append(DropdownItem(ID: DropdownOption.spam.rawValue, name: R.string.localizable.report_user_unauthorized_advertising()))
        items.append(DropdownItem(ID: DropdownOption.wrongCategory.rawValue, name: R.string.localizable.report_user_incorrectly_classified()))
        items.append(DropdownItem(ID: DropdownOption.poorPhotoQuality.rawValue, name: R.string.localizable.report_user_poor_photo_quality()))
        reasonDropdownView.items = items

        if let item = items.first(where: { $0.ID == selectedReason.rawValue }) {
            item.isSelected = true
            reasonTextField.text = item.name
        }

        reasonHeight.constant = CGFloat(items.count) * 48.0
    }

    private func setUpTextFields() {
        reasonTextField.placeholder = R.string.localizable.report_user_reason()
        reasonTextField.delegate = self

        commentTextField.placeholder = R.string.localizable.report_user_description()
        commentTextField.delegate = self
    }

    // MARK: - Actions

    @IBAction func sendAction(_: PrimaryLargeButton) {
        if let text = commentTextField.text, let reason = reasonMap[selectedReason] {
            sendCallback?(merchantId, reason, text)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ReportUserDialog: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == reasonTextField {
            isReasonOpened = !isReasonOpened
            reasonDropdownView.isHidden = !isReasonOpened
            return false
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - DropdownViewDelegate

extension ReportUserDialog: DropdownViewDelegate {
    func dropdownView(_ dropdownView: DropdownView, didSelect item: DropdownItem) {
        reasonTextField.text = item.name
        isReasonOpened = false
        reasonDropdownView.isHidden = true
        let selectedItems = dropdownView.getSelectedItems()
        if let firstItem = selectedItems.first {
            selectedReason = DropdownOption.allCases[firstItem]
        }
    }

    func dropdownView(_: DropdownView, didDeselect _: DropdownItem) {}
}
