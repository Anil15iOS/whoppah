//
//  HomeBlock.swift
//  Whoppah
//
//  Created by Eddie Long on 07/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class HomeBlock: UIView {
    static let identifier = "HomeBlock"
    static let nibName = "HomeBlock"
    private let bag = DisposeBag()
    let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3
    var listNumRows: Int { (viewModel?.numItems() ?? 6) / listNumCols }

    private let blockInset = UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
    weak var delegate: GridADCellDelegate?

    var viewModel: ProductBlockViewModel! {
        didSet {
            reload()
        }
    }

    override var bounds: CGRect {
        didSet {
            collectionViewHeight.constant = getHeightForCollectionView()
        }
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var allButton: UIButton!
    @IBOutlet var blockTitle: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Common Init

    private func commonInit() {
        Bundle.main.loadNibNamed(HomeBlock.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.pinToEdges(of: self, orientation: .vertical)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: GridADCell.nibName, bundle: nil), forCellWithReuseIdentifier: GridADCell.identifier)
        collectionView.isScrollEnabled = false
        collectionViewHeight.constant = getHeightForCollectionView()
    }

    // MARK: Actions

    @IBAction func showAll(_: UIButton) {
        viewModel.showAllClicked()
    }

    // MARK: Privates

    private func getHeightForCollectionView() -> CGFloat {
        let cellSize = getGridItemSize()
        let spacing = UIConstants.listInteritemVSpacing
        let totalSpacing = max(spacing * CGFloat(listNumRows - 1), 0)
        return cellSize.height * CGFloat(listNumRows) + totalSpacing
    }

    private func getGridItemSize() -> CGSize {
        let availableWidth = frame.width - blockInset.left - blockInset.right
        let width = availableWidth - (UIConstants.listInteritemHSpacing * CGFloat(listNumCols - 1))
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * GridADCell.aspect
        return CGSize(width: itemWidth, height: max(itemHeight, 0))
    }

    private func reload() {
        viewModel.title.bind(to: blockTitle.rx.text).disposed(by: bag)
        viewModel.buttonTitle.bind(to: allButton.rx.title()).disposed(by: bag)
        viewModel.allButtonEnabled.bind(to: allButton.rx.isVisible).disposed(by: bag)
        allButton.rx.tap.bind { [weak self] in
            self?.viewModel.showAllClicked()
        }.disposed(by: bag)

        collectionView.reloadData()
    }
}

extension HomeBlock: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = viewModel.cell(atIndex: indexPath.row) else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridADCell.identifier, for: indexPath) as! GridADCell
        cell.configure(withVM: item)
        cell.delegate = delegate
        return cell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.numItems()
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }
}

extension HomeBlock: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.cellClicked(atIndex: indexPath.row)
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt _: IndexPath) {}

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let cell = cell as? GridADCell {
            cell.stopVideo()
        }
    }
}

extension HomeBlock: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView(cv, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        // The view here is used instead of the collection view
        // This is because the viewDidLayoutSubviews reports a lower value here than the screen value (constraints not updated yet?)
        let cvWidth = frame.width
        let availableWidth = cvWidth - inset.left - inset.right
        let interitemSpacing = collectionView(cv, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section) * CGFloat(listNumCols - 1)
        let width = availableWidth - interitemSpacing
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * GridADCell.aspect
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
