//
//  MyAdsCell.swift
//  Whoppah
//
//  Created by Jose Camallonga on 26/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit

class MyAdsCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = String(describing: MyAdsCell.self)
    static let estimatedHeight: CGFloat = 44.0

    private lazy var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String, isEnabled: Bool) {
        selectionStyle = isEnabled ? .default : .none
        typeLabel.textColor = isEnabled ? .black : .silver
        isUserInteractionEnabled = isEnabled
        typeLabel.text = text
    }
}

// MARK: - Private

private extension MyAdsCell {
    func setupConstraints() {
        addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            typeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
