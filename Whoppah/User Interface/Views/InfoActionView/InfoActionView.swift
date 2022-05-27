//
//  InfoActionView.swift
//  Whoppah
//
//  Created by Jose Camallonga on 30/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxCocoa
import UIKit

class InfoActionView: UIView {
    // MARK: - Properties

    static let estimatedHeight: CGFloat = 224.0

    private lazy var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .silver
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = R.image.whoppah_usp_icon()?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriority(999), for: .vertical)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h3
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .smallText
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actionButton: PrimaryLargeButton = {
        let button = PrimaryLargeButton(frame: .zero)
        button.style = .primary
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var topConstraint: NSLayoutConstraint = {
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 42)
    }()

    var tapEvent: ControlEvent<Void> {
        actionButton.rx.tap
    }

    var isAnimating: Binder<Bool> {
        actionButton.rx.isAnimating
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String? = nil,
                   description: String? = nil,
                   action: String? = nil,
                   backgroundColor: UIColor = .orange,
                   topSeparation: CGFloat = 42,
                   isSeparatorHidden: Bool = true) {
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.setTitle(action, for: .normal)
        backgroundView.backgroundColor = backgroundColor
        actionButton.backgroundColor = backgroundColor
        separatorView.isHidden = isSeparatorHidden
        topConstraint.constant = topSeparation
    }
}

// MARK: - Private

private extension InfoActionView {
    func setupConstraints() {
        addSubview(separatorView)
        addSubview(backgroundView)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topConstraint,
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            iconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),

            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -14),

            actionButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            actionButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            actionButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
