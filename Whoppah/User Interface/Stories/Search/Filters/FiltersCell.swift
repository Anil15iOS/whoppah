//
//  FiltersCell.swift
//  Whoppah
//
//  Created by Jose Camallonga on 09/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import UIKit

class FiltersCell: UITableViewCell {
    static let identifier = String(describing: FiltersCell.self)
    static let estimatedHeight: CGFloat = 44.0
    private var selectedItems: [String] = [] {
        didSet {
            let itemsLabelText = selectedItems.joined(separator: ", ")
            itemsLabel.text = !selectedItems.isEmpty ? itemsLabelText : R.string.localizable.search_filters_category_select()
            colorsCollectionView.reloadData()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .label
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var itemsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .label
        label.textColor = .silver
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        collectionView.register(UINib(nibName: ColorCell.nibName, bundle: nil), forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, selected: [String], isColor: Bool) {
        titleLabel.text = title
        selectedItems = selected
        itemsLabel.isHidden = isColor && !selectedItems.isEmpty
        colorsCollectionView.isVisible = isColor && !selectedItems.isEmpty
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FiltersCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        selectedItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        cell.setUp(with: selectedItems[selectedItems.count - (indexPath.row + 1)])
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: 16.0, height: 16.0)
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

private extension FiltersCell {
    func setupConstraints() {
        addSubview(titleLabel)
        addSubview(itemsLabel)
        addSubview(colorsCollectionView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),

            itemsLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            itemsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            itemsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            itemsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            colorsCollectionView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            colorsCollectionView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
