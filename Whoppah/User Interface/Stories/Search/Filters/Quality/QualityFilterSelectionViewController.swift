//
//  QualityFilterSelectionViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class QualityFilterSelectionViewController: UIViewController {
    var viewModel: QualityFilterSelectionViewModel!
    private let bag = DisposeBag()

    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(frame: .zero)
        navigationBar.titleLabel.text = R.string.localizable.search_filters_condition_title()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.text = R.string.localizable.search_filters_condition_subtitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var qualitySelectionView: QualitySelectionView = {
        let view = QualitySelectionView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var banner: ViewFactory.BannerView = {
        let view = ViewFactory.createTextBanner(title: "", icon: R.image.quality_tick_icon(), iconSize: 24)
        view.root.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var saveButton: PrimaryLargeButton = {
        let button = PrimaryLargeButton(frame: .zero)
        button.setTitle(R.string.localizable.commonSave(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupBindings()
        viewModel.load()
    }
}

// MARK: - Private

private extension QualityFilterSelectionViewController {
    func setupBindings() {
        navigationBar.backButton.rx.tap
            .bind(to: viewModel.inputs.dismiss)
            .disposed(by: bag)

        viewModel.outputs.quality
            .compactMap { $0 }
            .bind(to: qualitySelectionView.inputs.quality)
            .disposed(by: bag)
        viewModel.outputs.quality
            .map { $0?.explanationText() }
            .bind(to: banner.text.rx.text)
            .disposed(by: bag)
        viewModel.outputs.quality
            .map { $0 != nil }
            .bind(to: saveButton.rx.isEnabled, banner.root.rx.isVisible)
            .disposed(by: bag)

        qualitySelectionView.outputs.qualityRelay
            .map { $0 != nil }
            .bind(to: saveButton.rx.isEnabled, banner.root.rx.isVisible)
            .disposed(by: bag)
        qualitySelectionView.outputs.qualityRelay
            .map { $0?.explanationText() }
            .bind(to: banner.text.rx.text)
            .disposed(by: bag)

        saveButton.rx.tap
            .map { [unowned self] in self.qualitySelectionView.selectedQuality }
            .bind(to: viewModel.inputs.save)
            .disposed(by: bag)
    }

    func setupConstraints() {
        view.addSubview(navigationBar)
        view.addSubview(titleLabel)
        view.addSubview(qualitySelectionView)
        view.addSubview(banner.root)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            qualitySelectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            qualitySelectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            qualitySelectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            banner.root.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            banner.root.topAnchor.constraint(equalTo: qualitySelectionView.bottomAnchor, constant: 16),
            banner.root.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
