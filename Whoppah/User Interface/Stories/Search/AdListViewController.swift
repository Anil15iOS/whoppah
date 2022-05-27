//
//  AdListViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import SkeletonView
import UIKit
import WhoppahCore

protocol SearchListInterface: AnyObject {
    func refetchAds()
    func loadMoreAds()

    func didSelectAd(ad: AdViewModel)
    func didViewVideo(ad: AdViewModel)

    func getNumberOfAds() -> Int
    func getAdViewModel(atIndex: Int) -> AdViewModel?

    func scrollViewDidScroll(scrollView: UIScrollView)
}

class AdListViewController: UIViewController {
    enum AdListType {
        case filtered
        case user
    }

    // MARK: Outlets

    @IBOutlet var resultsCollectionView: UICollectionView!

    // MARK: Properties

    weak var delegate: SearchListInterface?
    var presentationStyle: ListPresentation = .grid
    var listType = AdListType.filtered
    var emptyView: UIView?
    private let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3

    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
    }

    private func setUpCollectionViews() {
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
        resultsCollectionView.register(UINib(nibName: GridADCell.nibName, bundle: nil), forCellWithReuseIdentifier: GridADCell.identifier)
        resultsCollectionView.register(UINib(nibName: ListADCell.nibName, bundle: nil), forCellWithReuseIdentifier: ListADCell.identifier)
        resultsCollectionView.bindHeadRefreshHandler({
            self.delegate?.refetchAds()
        }, themeColor: .orange, refreshStyle: .native)
        resultsCollectionView.bindFootRefreshHandler(nil, themeColor: .orange, refreshStyle: .native)
        resultsCollectionView.isSkeletonable = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resultsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension AdListViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        switch collectionSkeletonView {
        case resultsCollectionView:
            return 1
        default:
            assertionFailure("Missing cell")
            return 1
        }
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        switch skeletonView {
        case resultsCollectionView:
            return 12
        default:
            assertionFailure("Unexpected cell type")
            return 0
        }
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case resultsCollectionView:
            return presentationStyle == .grid ? GridADCell.identifier : ListADCell.identifier
        default:
            assertionFailure("Missing cell")
            return ""
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AdListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        switch collectionView {
        case resultsCollectionView:
            let numberOfAds = delegate!.getNumberOfAds()
            emptyView?.isVisible = numberOfAds == 0
            return numberOfAds
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case resultsCollectionView:
            if presentationStyle == .grid {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridADCell.identifier, for: indexPath) as! GridADCell
                if let vm = delegate?.getAdViewModel(atIndex: indexPath.row) { cell.configure(withVM: vm) }
                cell.delegate = self
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListADCell.identifier, for: indexPath) as! ListADCell
                if let vm = delegate?.getAdViewModel(atIndex: indexPath.row) { cell.configure(withVM: vm) }
                cell.delegate = self
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AdListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case resultsCollectionView:
            guard let ad = delegate?.getAdViewModel(atIndex: indexPath.row) else { return }
            ad.onClicked()
            delegate?.didSelectAd(ad: ad)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case resultsCollectionView:
            if collectionView.needsLoadsMore(presentation: presentationStyle,
                                             row: indexPath.row,
                                             totalItems: delegate!.getNumberOfAds(),
                                             numsColums: listNumCols) {
                DispatchQueue.main.async {
                    self.delegate?.loadMoreAds()
                }
            }
        default:
            break
        }
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let cell = cell as? ListADCell {
            cell.stopVideo()
        } else if let cell = cell as? GridADCell {
            cell.stopVideo()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: scrollView)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AdListViewController: UICollectionViewDelegateFlowLayout {
    private func getCellSize() -> CGSize {
        if presentationStyle == .grid {
            let availableWidth = view.frame.width - 32
            let width = availableWidth - (UIConstants.listInteritemHSpacing * CGFloat(listNumCols - 1))
            let itemWidth = width / CGFloat(listNumCols)
            let itemHeight = itemWidth * GridADCell.aspect
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            return CGSize(width: resultsCollectionView.bounds.width - 32.0, height: resultsCollectionView.bounds.width - 32.0 + 58)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        switch collectionView {
        case resultsCollectionView:
            return getCellSize()
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        switch collectionView {
        case resultsCollectionView:
            if presentationStyle == .grid {
                return UIEdgeInsets(top: 0, left: 16.0, bottom: 32.0, right: 16.0)
            } else {
                return UIEdgeInsets(top: 0, left: 16.0, bottom: 32.0, right: 16.0)
            }
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case resultsCollectionView:
            return 16.0
        default:
            return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case resultsCollectionView:
            return 16.0
        default:
            return 0.0
        }
    }

    private func didClickLike(_ ad: AdViewModel) {
        getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupFavoritesTitle(),
                                                  description: R.string.localizable.contextualSignupFavoritesDescription()) {
            let observer = ad.toggleLikeStatus()
            observer
                .observeOn(MainScheduler.instance)
                .subscribe(onError: { [weak self] error in
                    self?.showError(error)
                }).disposed(by: self.bag)
            observer.connect().disposed(by: self.bag)
        }
    }
}

// MARK: - GridADCellDelegate

extension AdListViewController: GridADCellDelegate {
    func gridAdCell(_ cell: GridADCell, didClickLike _: RoundedButton) {
        didClickLike(cell.ad)
    }

    func gridAdCellDidViewVideo(_ cell: GridADCell) {
        delegate?.didViewVideo(ad: cell.ad)
    }
}

// MARK: - ListADCellDelegate

extension AdListViewController: ListADCellDelegate {
    func listAdCell(_ cell: ListADCell, didClickLike _: UIButton) {
        didClickLike(cell.ad)
    }

    func listAdCellDidViewVideo(_ cell: ListADCell) {
        delegate?.didViewVideo(ad: cell.ad)
    }
}
