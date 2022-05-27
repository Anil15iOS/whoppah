//
//  ReportProductDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

class ReportProductDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var commentTextField: WPTextField!
    @IBOutlet var sendButton: PrimaryLargeButton!
    @IBOutlet var reasonStackView: UIStackView!
    @IBOutlet var reasonTextField: WPTextField!

    // MARK: Properties

    private var itemId: UUID
    private var reasonDropdownView: DropdownView!
    private var selectedReason = DropdownOption.inappropriateContent
    var reasonHeight: NSLayoutConstraint!
    var isReasonOpened: Bool = false
    var sendCallback: ((UUID, GraphQL.AbuseReportReason, String) -> Void)?

    enum DropdownOption: String, CaseIterable {
        case inappropriateContent = "inappropriate"
        case spam = "spam"
        case wrongCategory = "wrong_category"
        case poorPhotoQuality = "poor_photo"
    }

    let reasonMap: [DropdownOption: GraphQL.AbuseReportReason] = [
        .inappropriateContent: GraphQL.AbuseReportReason.violatingContent,
        .wrongCategory: GraphQL.AbuseReportReason.wrongCategory,
        .spam: GraphQL.AbuseReportReason.spam,
        .poorPhotoQuality: GraphQL.AbuseReportReason.poorPhotoQuality
    ]

    init(itemId: UUID) {
        self.itemId = itemId
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDropdown()
        setUpTextFields()
        setUpButtons()
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
        items.append(DropdownItem(ID: DropdownOption.inappropriateContent.rawValue, name: R.string.localizable.report_product_inappropriate_content()))
        items.append(DropdownItem(ID: DropdownOption.spam.rawValue, name: R.string.localizable.report_product_spam()))
        items.append(DropdownItem(ID: DropdownOption.wrongCategory.rawValue, name: R.string.localizable.report_product_incorrectly_classified()))
        items.append(DropdownItem(ID: DropdownOption.poorPhotoQuality.rawValue, name: R.string.localizable.report_product_poor_photo_quality()))
        reasonDropdownView.items = items
        
        if let item = items.first(where: { $0.ID == selectedReason.rawValue }) {
            item.isSelected = true
            reasonTextField.text = item.name
        }

        reasonHeight.constant = CGFloat(items.count) * 48.0
    }

    private func setUpTextFields() {
        reasonTextField.placeholder = R.string.localizable.report_product_reason()
        reasonTextField.delegate = self

        commentTextField.placeholder = R.string.localizable.report_product_description()
        commentTextField.delegate = self
    }

    private func setUpButtons() {
        sendButton.style = .primary
    }

    // MARK: - Actions

    @IBAction func sendAction(_: PrimaryLargeButton) {
        if let text = commentTextField.text, let reason = reasonMap[selectedReason] {
            sendCallback?(itemId, reason, text)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ReportProductDialog: UITextFieldDelegate {
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

extension ReportProductDialog: DropdownViewDelegate {
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
