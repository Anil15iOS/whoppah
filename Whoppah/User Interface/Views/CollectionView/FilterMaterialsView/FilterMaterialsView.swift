//
//  MaterialsView.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/5/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

// MARK: - FilterMaterialsViewDelegate

protocol FilterMaterialsViewDelegate: AnyObject {
    func materialView(_ materialView: FilterMaterialsView, didSelectMaterial material: FilterAttribute)
    func materialView(_ materialView: FilterMaterialsView, didDeselectMaterial material: FilterAttribute)
}

class FilterMaterialsView: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Properties

    weak var delegate: FilterMaterialsViewDelegate?
    var maxNumberOfSelectedMaterials: Int = 3
    var numberOfSelectedMaterials: Int = 0
    var numberOfColomns: Int = 3
    var materials: [FilterAttribute] = [] { didSet { collectionView.reloadData() } }
    var selectedMaterials: [FilterAttribute]?
    var numberOfRows: Int {
        Int((Double(materials.count) / Double(numberOfColomns)).rounded(.up))
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

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("FilterMaterialsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: FilterMaterialCell.nibName, bundle: nil), forCellWithReuseIdentifier: FilterMaterialCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension FilterMaterialsView: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        materials.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterMaterialCell.identifier, for: indexPath) as! FilterMaterialCell
        cell.setUp(with: materials[indexPath.row])
        if let favoriteMaterials = selectedMaterials {
            cell.isSelected = favoriteMaterials.contains(where: { $0.slug == materials[indexPath.row].slug }) ? true : false
        } else {
            cell.isSelected = false
        }

        if cell.isSelected {
            // Selecting an item along is not enough, the collection view
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FilterMaterialsView: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, shouldSelectItemAt _: IndexPath) -> Bool {
        numberOfSelectedMaterials < maxNumberOfSelectedMaterials
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let material = materials[indexPath.row]
        selectedMaterials?.append(material)
        delegate?.materialView(self, didSelectMaterial: material)
        numberOfSelectedMaterials += 1
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let material = materials[indexPath.row]
        selectedMaterials?.removeAll(where: { $0.slug == material.slug })
        delegate?.materialView(self, didDeselectMaterial: material)
        numberOfSelectedMaterials -= 1
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilterMaterialsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32.0) / CGFloat(numberOfColomns)
        return CGSize(width: width, height: 50.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        0.0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        0.0
    }
}
