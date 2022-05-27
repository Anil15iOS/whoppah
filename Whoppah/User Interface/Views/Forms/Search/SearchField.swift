//
//  SearchField.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol SearchFieldDelegate: AnyObject {
    func searchFieldDidBeginEditing(_ searchField: SearchField)
    func searchFieldDidEndEditing(_ searchField: SearchField)
    func searchFieldDidClickCamera(_ searchField: SearchField)
    func searchFieldDidReturn(_ searchField: SearchField)
    func searchField(_ searchField: SearchField, didChangeText text: String)
}

extension SearchFieldDelegate {
    func searchFieldDidEndEditing(_: SearchField) {}
}

class SearchField: UIView {
    enum State {
        case empty
        case filled
        case selected
        case inactive
    }

    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var textFieldBackgroundView: UIView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var clearButton: UIButton!

    // MARK: - Properties

    var state: State = .empty { didSet { updateAppearanceAnimated() } }
    weak var delegate: SearchFieldDelegate?

    var text: String { textField.text ?? "" }
    var autocompleteDropdown = DropDown()
    /* var items: [AutocompleteItem] = [] {
         didSet {
             autocompleteDropdown.dataSource = items.map({ $0.title })
             autocompleteDropdown.reloadAllComponents()
             autocompleteDropdown.dropDownHeight = items.count < 4 ? CGFloat(items.count) * 48.0 : 48.0 * 4
         }
     } */

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
        Bundle.main.loadNibNamed("SearchField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 4.0

        updateAppearance()

        textField.delegate = self
        textField.placeholder = R.string.localizable.search_field_default_text()
        textFieldBackgroundView.layer.cornerRadius = 4.0

        autocompleteDropdown.anchorView = self
        autocompleteDropdown.direction = .bottom
        autocompleteDropdown.cellHeight = 48.0
        autocompleteDropdown.cellNib = UINib(nibName: "AutocompleteCell", bundle: nil)
        autocompleteDropdown.customCellConfiguration = { /* [unowned self] */ (_: Index, _: String, _: DDDropDownCell) -> Void in
            // guard let cell = cell as? AutocompleteCell else { return }
            // cell.configure(with: self.items[index])
        }

        autocompleteDropdown.selectionAction = { [unowned self] (_: Int, _: String) in
            self.textField.resignFirstResponder()
            assertionFailure("Implement this")
        }

        autocompleteDropdown.width = bounds.width
        autocompleteDropdown.shadowRadius = 3
        autocompleteDropdown.shadowColor = UIColor.silver
        autocompleteDropdown.bottomOffset = CGPoint(x: 0, y: bounds.height + 4.0)
    }

    // MARK: - Appearance

    private func updateAppearanceAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.updateAppearance()
        }
    }

    private func updateAppearance() {
        switch state {
        case .empty:
            iconView.tintColor = .steel
            clearButton.isHidden = true
        case .filled:
            iconView.tintColor = .space
            clearButton.isHidden = false
        case .selected:
            iconView.tintColor = .space
            clearButton.isHidden = false
        case .inactive:
            iconView.tintColor = .silver
            clearButton.isHidden = true
        }
    }

    // MARK: - Actions

    @IBAction func cameraAction(_: UIButton) {
        delegate?.searchFieldDidClickCamera(self)
    }

    @IBAction func clearAction(_: UIButton) {
        textField.text = nil
        state = textField.isEditing ? .selected : .empty
        delegate?.searchField(self, didChangeText: "")
    }
}

// MARK: - UITextFieldDelegate

extension SearchField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        state = .selected
        delegate?.searchFieldDidBeginEditing(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        state = (textField.text != nil && textField.text!.isEmpty) ? .empty : .filled
        autocompleteDropdown.hide()
        delegate?.searchFieldDidEndEditing(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchFieldDidReturn(self)
        textField.resignFirstResponder()
        return true
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        delegate?.searchField(self, didChangeText: textField.text!)
    }
}
