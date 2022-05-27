//
//  ColorFilterSelectionViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class ColorFilterSelectionViewController: UIViewController {
    var viewModel: ColorFilterSelectionViewModel!
    private let bag = DisposeBag()

    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(frame: .zero)
        navigationBar.titleLabel.text = R.string.localizable.create_ad_main_color_title()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.text = R.string.localizable.search_filters_colors_subtitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: ColorCell.nibName, bundle: nil), forCellWithReuseIdentifier: ColorCell.identifier)
        return collectionView
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

// MARK: - UICollectionViewDelegateFlowLayout

extension ColorFilterSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: 40.0, height: 40.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }
}

// MARK: - Private

private extension ColorFilterSelectionViewController {
    func setupBindings() {
        navigationBar.backButton.rx.tap
            .bind(to: viewModel.inputs.dismiss)
            .disposed(by: bag)

        viewModel.outputs.colors
            .bind(to: colorsCollectionView.rx.items(cellIdentifier: ColorCell.identifier, cellType: ColorCell.self)) { _, viewModel, cell in
                cell.setUp(with: viewModel)
            }.disposed(by: bag)

        Observable
            .zip(colorsCollectionView.rx.itemSelected, colorsCollectionView.rx.modelSelected(ColorViewModel.self))
            .bind { [weak self] indexPath, model in
                guard let self = self else { return }
                model.selected = !model.selected
                let cell = self.colorsCollectionView.cellForItem(at: indexPath) as! ColorCell
                cell.state = model.selected ? .selected : .normal
                self.viewModel.colorSelected(vm: model)
            }.disposed(by: bag)

        viewModel.outputs.saveEnabled
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)

        saveButton.rx.tap
            .bind(to: viewModel.inputs.save)
            .disposed(by: bag)
    }

    func setupConstraints() {
        view.addSubview(navigationBar)
        view.addSubview(titleLabel)
        view.addSubview(colorsCollectionView)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            colorsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorsCollectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
