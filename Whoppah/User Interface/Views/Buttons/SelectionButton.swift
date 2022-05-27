//
//  SelectionButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/8/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

@IBDesignable
class SelectionButton: UIControl {
    // MARK: - Properties

    private var stackView: UIStackView!
    private var disclosureView: UIImageView!
    private var nameLabel: UILabel!
    private var detailsLabel: UILabel!

    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    var details: String = "" {
        didSet {
            // Always show the error if it is set
            // When the error is cleared the details will be shown
            if error.isEmpty {
                detailsLabel.text = details
            }
            detailsLabel.isHidden = detailsLabel.text!.isEmpty

            layer.borderColor = error.isEmpty ? UIColor.blue.cgColor : UIColor.redInvalid.cgColor
            nameLabel.textColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
            detailsLabel.textColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
            disclosureView.tintColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
        }
    }

    var error: String = "" {
        didSet {
            // If clearing the error we put the details text in
            if error.isEmpty {
                detailsLabel.text = details
            } else {
                detailsLabel.text = error
            }
            detailsLabel.isHidden = detailsLabel.text!.isEmpty

            layer.borderColor = error.isEmpty ? UIColor.blue.cgColor : UIColor.redInvalid.cgColor
            nameLabel.textColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
            detailsLabel.textColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
            disclosureView.tintColor = error.isEmpty ? UIColor.blue : UIColor.redInvalid
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Common Init

    private func commonInit() {
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0

        disclosureView = UIImageView(frame: CGRect(x: bounds.width - 40.0, y: bounds.height / 2 - 20.0, width: 40.0, height: 40.0))
        disclosureView.contentMode = .center
        disclosureView.image = R.image.ic_arrow_big_right()
        disclosureView.tintColor = .blue
        addSubview(disclosureView)

        stackView = UIStackView(frame: CGRect(x: 16.0, y: 8.0, width: bounds.width - 32.0, height: bounds.height - 16.0))
        stackView.axis = .vertical
        addSubview(stackView)

        nameLabel = UILabel()
        nameLabel.font = UIFont.button
        nameLabel.textColor = .blue
        stackView.addArrangedSubview(nameLabel)

        detailsLabel = UILabel()
        detailsLabel.font = UIFont.descriptionText
        detailsLabel.textColor = .steel
        stackView.addArrangedSubview(detailsLabel)
    }

    override func layoutSubviews() {
        disclosureView.frame = CGRect(x: bounds.width - 40.0, y: bounds.height / 2 - 20.0, width: 40.0, height: 40.0)
        stackView.frame = CGRect(x: 16.0, y: 8.0, width: bounds.width - 32.0, height: bounds.height - 16.0)
    }
}
