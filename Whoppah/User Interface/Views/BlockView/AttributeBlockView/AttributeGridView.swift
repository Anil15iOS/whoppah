//
//  AttributeGridView.swift
//  Whoppah
//
//  Created by Eddie Long on 02/07/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class AttributeGridView: UIView {
    static let identifier = "AttributeGridView"
    static let nibName = "AttributeGridView"
    private let bag = DisposeBag()
    let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3
    var listNumRows: Int { Int(ceil(Double(viewModel.sections.count) / Double(listNumCols))) }

    private let blockInset = UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
    
    private var viewModel: AttributeBlockViewModel!
    override var bounds: CGRect {
        didSet {
            collectionViewHeight.constant = getHeightForCollectionView()
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var blockTitle: UILabel!
    @IBOutlet var blockDummyView: UIView!

    // MARK: - Initialization
    
    init(viewModel: AttributeBlockViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Unimplemented")
    }
    
    // MARK: - Common Init

    private func commonInit() {
        Bundle.main.loadNibNamed(AttributeGridView.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.pinToEdges(of: self, orientation: .vertical)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: AttributeTextButtonCell.nibName, bundle: nil), forCellWithReuseIdentifier: AttributeTextButtonCell.identifier)
        collectionView.isScrollEnabled = false
        collectionViewHeight.constant = getHeightForCollectionView()
        
        reload()
    }

    // MARK: Privates

    private func getHeightForCollectionView() -> CGFloat {
        let cellSize = getGridItemSize()
        let spacing = UIConstants.listInteritemVSpacing
        let totalSpacing = spacing * CGFloat(listNumRows - 1)
        return cellSize.height * CGFloat(listNumRows) + totalSpacing
    }

    private func getGridItemSize() -> CGSize {
        let availableWidth = frame.width - blockInset.left - blockInset.right
        let width = availableWidth - (UIConstants.listInteritemHSpacing * CGFloat(listNumCols - 1))
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * AttributeTextButtonCell.aspect
        return CGSize(width: itemWidth, height: max(itemHeight, 0))
    }

    private func reload() {
        viewModel.title.bind(to: blockTitle.rx.text).disposed(by: bag)
        viewModel.title.map { $0 == nil }.bind(to: blockTitle.rx.isHidden).disposed(by: bag)
        viewModel.title.map { $0 == nil }.bind(to: blockDummyView.rx.isHidden).disposed(by: bag)
        
        collectionView.reloadData()
    }
}

extension AttributeGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.sections[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeTextButtonCell.identifier, for: indexPath) as! AttributeTextButtonCell
        cell.configure(with: item)
        item.outputs.objectClick.bind(to: viewModel.outputs.sectionClicked).disposed(by: bag)
        return cell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.sections.count
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }
}

extension AttributeGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView(cv, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        // The view here is used instead of the collection view
        // This is because the viewDidLayoutSubviews reports a lower value here than the screen value (constraints not updated yet?)
        let cvWidth = frame.width
        let availableWidth = cvWidth - inset.left - inset.right
        let interitemSpacing = collectionView(cv, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section) * CGFloat(listNumCols - 1)
        let width = availableWidth - interitemSpacing
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * AttributeTextButtonCell.aspect
        return CGSize(width: itemWidth, height: max(itemHeight, 0))
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        UIConstants.listInteritemHSpacing
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        UIConstants.listInteritemHSpacing
    }
}
