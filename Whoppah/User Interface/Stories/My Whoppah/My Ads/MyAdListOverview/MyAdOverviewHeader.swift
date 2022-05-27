//
//  MyAdOverviewHeader.swift
//  Whoppah
//
//  Created by Jose Camallonga on 30/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit

class MyAdOverviewHeader: UICollectionReusableView {
    static let identifier = String(describing: MyAdOverviewHeader.self)

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}

// MARK: - Private

private extension MyAdOverviewHeader {
    func setupConstraints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
