//
//  FiltersViewFooter.swift
//  Whoppah
//
//  Created by Jose Camallonga on 09/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxCocoa

class FiltersViewFooter: UIView {
    static let estimatedHeight: CGFloat = 294.0

    private lazy var separatorView: UIView = {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .silver
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()

    private lazy var filterButton: PrimaryLargeButton = {
        let button = PrimaryLargeButton(frame: .zero)
        button.setTitle(R.string.localizable.search_filters_show_results_btn(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var resetButton: SecondaryLargeButton = {
        let button = SecondaryLargeButton(frame: .zero)
        button.setTitle(R.string.localizable.search_filters_clear_btn(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var saveQueryView: InfoActionView = {
        let view = InfoActionView(frame: .zero)
        view.configure(with: R.string.localizable.search_filters_save_title(),
                       description: R.string.localizable.search_filters_save_description(),
                       action: R.string.localizable.search_filters_btn_save(),
                       backgroundColor: .green,
                       topSeparation: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension FiltersViewFooter {
    var filterTapped: ControlEvent<Void> {
        filterButton.rx.tap
    }

    var filterEnabled: Binder<Bool> {
        filterButton.rx.isEnabled
    }

    var resetTapped: ControlEvent<Void> {
        resetButton.rx.tap
    }

    var saveQueryTapped: ControlEvent<Void> {
        saveQueryView.tapEvent
    }

    var isAnimating: Binder<Bool> {
        saveQueryView.isAnimating
    }
}

// MARK: - Private

private extension FiltersViewFooter {
    func setupConstraints() {
        addSubview(separatorView)
        addSubview(filterButton)
        addSubview(resetButton)
        addSubview(saveQueryView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            resetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            resetButton.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            resetButton.widthAnchor.constraint(equalToConstant: 112),
            resetButton.heightAnchor.constraint(equalToConstant: 48),

            filterButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 12),
            filterButton.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 48),

            saveQueryView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 8),
            saveQueryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            saveQueryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            saveQueryView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
