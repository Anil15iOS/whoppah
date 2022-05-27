//
//  HorizontalScrollableList.swift
//  Whoppah
//
//  Created by Eddie Long on 22/06/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import SkeletonView
import RxCocoa

class HorizontalScrollableList: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var allButton: UIButton!
    @IBOutlet var blockTitle: UILabel!

    private let blockInset = UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)

    var viewModel: AttributeBlockViewModel!
    private var cellVMs = [CircleImageCellViewModel]()
    private var bag: DisposeBag!

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

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("HorizontalScrollableList", owner: self, options: nil)
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinToEdges(of: self, orientation: .horizontal)
        contentView.pinToEdges(of: self, orientation: .vertical)
        
        collectionView.register(UINib(nibName: CircleImageCell.nibName, bundle: nil), forCellWithReuseIdentifier: CircleImageCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    func configure(withVM vm: AttributeBlockViewModel) {
        viewModel = vm
        bag = DisposeBag()
        
        viewModel.title.bind(to: blockTitle.rx.text).disposed(by: bag)
        viewModel.button.bind(to: allButton.rx.title()).disposed(by: bag)
        viewModel.button.map { $0 != nil }.bind(to: allButton.rx.isVisible).disposed(by: bag)
        allButton.rx.tap.bind { [weak self] in
            self?.viewModel.didClickButton()
        }.disposed(by: bag)

        cellVMs = viewModel.sections.compactMap { [weak self] attribute -> CircleImageCellViewModel? in
            guard let self = self else { return nil }
            
            let size = self.collectionView(self.collectionView,
                                           layout: self.collectionView.collectionViewLayout,
                                           sizeForItemAt: IndexPath(row: 0, section: 0))
            self.collectionViewHeightConstraint.constant = size.height + 10
            
            let vm = CircleImageCellViewModel(title: attribute.title, url: attribute.image, slug: attribute.slug)
            attribute.outputs.objectClick
            .bind(to: self.viewModel.outputs.sectionClicked)
            .disposed(by: self.bag)
            vm.outputs.itemClicked.subscribe(onNext: {
                attribute.cellClicked()
            }).disposed(by: self.bag)
            
            return vm
        }
        print(viewModel.sections)
    }
}

extension HorizontalScrollableList: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 6
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
        return CircleImageCell.identifier
    }
}

extension HorizontalScrollableList: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        cellVMs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleImageCell.identifier, for: indexPath) as! CircleImageCell
        cell.hideSkeleton()
        cell.configure(with: cellVMs[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HorizontalScrollableList: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellVMs[indexPath.row].onClick()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalScrollableList: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let inset = blockInset
        // The view here is used instead of the collection view
        // This is because the viewDidLayoutSubviews reports a lower value here than the screen value (constraints not updated yet?)
        let cvWidth = contentView.frame.width
        let availableWidth = cvWidth - inset.left - inset.right
        var itemSize = 78
        outer: while true {
            let numCols = (Float(availableWidth) / Float(itemSize))
            let fraction = numCols.truncatingRemainder(dividingBy: 1.0)
            // Aim to have 30-70% of the next cell visible
            switch fraction {
            case ...0.3:
                itemSize -= 1
            case 0.7...:
                itemSize += 1
            default:
                break outer
            }
        }

        let aspect = 0.8125
        return CGSize(width: Double(itemSize), height: Double(itemSize) / aspect)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        0.0
    }
}
