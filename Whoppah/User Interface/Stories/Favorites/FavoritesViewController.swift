//
//  FavoritesViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/14/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import KafkaRefresh
import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

class FavoritesViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var navigationBarHeight: NSLayoutConstraint!

    @IBOutlet var myFavoritesLabel: UILabel!
    @IBOutlet var myFavoritesCollectionView: UICollectionView!

    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet var emptyFavoritesView: UIScrollView!
    @IBOutlet var favoriteImage: UIImageView!
    @IBOutlet var emptyFavoritesTitle: UILabel!
    @IBOutlet var emptyFavoritesSubtitle: UILabel!
    @IBOutlet var topFavoritesLabel: UILabel!
    @IBOutlet var topFavoritesCollectionView: UICollectionView!
    @IBOutlet var changeAdsPresentationButton: UIButton!
    @IBOutlet var countLabel: UILabel!

    private let bag = DisposeBag()
    var viewModel: FavoritesViewModel!
    private var favoritesPage = PublishRelay<Int>()
    private let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3
    var withNavBar: Bool = false

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpCollectionView()
        setUpEmptyView()
        setUpButtons()
        setUpFavorites()
        setUpRecommendedItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadAds()
        loadRecommendedItems()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myFavoritesCollectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: -

    private func setUpNavigationBar() {
        if withNavBar {
            navigationBar.titleLabel.text = R.string.localizable.main_favs_title()
            navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        } else {
            navigationBar.isHidden = true
            navigationBarHeight.constant = 0
        }
    }

    private func setUpButtons() {
        changeAdsPresentationButton.setImage(R.image.ic_list(), for: .normal)
        changeAdsPresentationButton.setImage(R.image.ic_listGrid(), for: .selected)
    }

    private func setUpEmptyView() {
        favoriteImage.layer.shadowColor = UIColor.black.cgColor
        favoriteImage.layer.shadowOpacity = 0.1
        favoriteImage.layer.shadowRadius = 24
        favoriteImage.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    private func setUpCollectionView() {
        myFavoritesCollectionView.dataSource = self
        myFavoritesCollectionView.delegate = self
        myFavoritesCollectionView.register(UINib(nibName: GridADCell.nibName, bundle: nil),
                                           forCellWithReuseIdentifier: GridADCell.identifier)
        myFavoritesCollectionView.register(UINib(nibName: ListADCell.nibName, bundle: nil),
                                           forCellWithReuseIdentifier: ListADCell.identifier)

        myFavoritesCollectionView.bindHeadRefreshHandler({
            self.reloadAds()
        }, themeColor: UIColor.orange, refreshStyle: .native)
        myFavoritesCollectionView.bindFootRefreshHandler(nil, themeColor: UIColor.orange, refreshStyle: .native)

        topFavoritesCollectionView.delegate = self
        topFavoritesCollectionView.register(UINib(nibName: GridADCell.nibName, bundle: nil),
                                            forCellWithReuseIdentifier: GridADCell.identifier)
    }

    private func setUpFavorites() {
        viewModel.favoriteList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .initial, .loadingInitial:
                    break
                default:
                    self.emptyFavoritesView.isVisible = self.viewModel.getNumberOfFavoriteItems() == 0
                }
                self.countLabel.text = R.string.localizable.main_favs_count_title(self.viewModel.getNumberOfFavoriteItems()).uppercased()
                self.myFavoritesCollectionView.applyAction(action, pager: self.viewModel.favoriteItemsPager)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        favoritesPage
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.loadMoreFavoriteItems() {
                    self.myFavoritesCollectionView.showFooterRefreshControl()
                } else {
                    self.myFavoritesCollectionView.hideRefreshControls(self.viewModel.favoriteItemsPager)
                }
            }).disposed(by: bag)

        viewModel.outputs.showLoading.bind(to: loadingViewContainer.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showLoading.bind(to: loadingView.rx.isLoading).disposed(by: bag)
    }

    private func setUpRecommendedItems() {
        viewModel.outputs.recommendedItems.bind(to: topFavoritesCollectionView.rx.items(cellIdentifier: GridADCell.identifier, cellType: GridADCell.self)) { [weak self] _, viewModel, cell in
            guard let self = self else { return }
            cell.configure(withVM: viewModel)
            cell.nameLabel.numberOfLines = 1
            cell.delegate = self
        }.disposed(by: bag)

        topFavoritesCollectionView.rx.modelSelected(AdViewModel.self).subscribe(onNext: { [weak self] model in
            self?.viewModel.recommendedItemSelected(ad: model)
        }).disposed(by: bag)
        viewModel.outputs.recommendedItems.map { $0.isEmpty }.bind(to: topFavoritesLabel.rx.isHidden).disposed(by: bag)
    }

    private func reloadAds() {
        favoritesPage.accept(1)
        viewModel.loadFavoriteItems()
    }

    private func loadRecommendedItems() {
        viewModel.loadRecommendedItems()
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func changeAdsPresentationAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.changeFavoriteItemsPresentation(sender.isSelected ? .list : .grid)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        switch collectionView {
        case myFavoritesCollectionView:
            return viewModel.getNumberOfFavoriteItems()
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case myFavoritesCollectionView:
            let ad = viewModel.getFavoriteCell(row: indexPath.row)
            if viewModel.favoriteListPresentationMode == .grid {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridADCell.identifier, for: indexPath) as! GridADCell
                cell.configure(withVM: ad)
                cell.delegate = self
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListADCell.identifier, for: indexPath) as! ListADCell
                cell.configure(withVM: ad)
                cell.delegate = self
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case myFavoritesCollectionView:
            viewModel.favoriteSelected(indexPath.row)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt _: IndexPath) {
        switch collectionView {
        case myFavoritesCollectionView, topFavoritesCollectionView:
            if let cell = cell as? ListADCell {
                cell.stopVideo()
            } else if let cell = cell as? GridADCell {
                cell.stopVideo()
            }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        switch collectionView {
        case myFavoritesCollectionView:
            if viewModel.favoriteListPresentationMode == .grid {
                let availableWidth = view.frame.width - 32
                let width = availableWidth - (UIConstants.listInteritemHSpacing * CGFloat(listNumCols - 1))
                let itemWidth = width / CGFloat(listNumCols)
                let itemHeight = itemWidth * GridADCell.aspect
                return CGSize(width: itemWidth, height: itemHeight)
            } else {
                return CGSize(width: collectionView.bounds.width - 32.0, height: collectionView.bounds.width - 32 + 58)
            }
        case topFavoritesCollectionView:
            return CGSize(width: 156.0, height: 216.0)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets {
        switch collectionView {
        case myFavoritesCollectionView:
            return UIEdgeInsets(top: 0, left: 16.0, bottom: 32.0, right: 16.0)
        case topFavoritesCollectionView:
            return UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case myFavoritesCollectionView, topFavoritesCollectionView:
            return 16.0
        default:
            return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case myFavoritesCollectionView, topFavoritesCollectionView:
            return 16.0
        default:
            return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay _: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch collectionView {
        case myFavoritesCollectionView:
            if collectionView.needsLoadsMore(presentation: viewModel.favoriteListPresentationMode,
                                             row: indexPath.row,
                                             totalItems: viewModel.getNumberOfFavoriteItems(),
                                             numsColums: listNumCols) {
                DispatchQueue.main.async { self.favoritesPage.accept(self.viewModel.favoriteItemsPager.nextPage) }
            }
        default:
            break
        }
    }
}

// MARK: - GridADCellDelegate

extension FavoritesViewController: GridADCellDelegate {
    func gridAdCell(_ cell: GridADCell, didClickLike _: RoundedButton) {
        viewModel.likeAd(cell.ad)
    }

    func gridAdCellDidViewVideo(_ cell: GridADCell) {
        viewModel.trackVideoViewed(cell.ad)
    }
}

// MARK: - ListADCellDelegate

extension FavoritesViewController: ListADCellDelegate {
    func listAdCell(_ cell: ListADCell, didClickLike _: UIButton) {
        viewModel.likeAd(cell.ad)
    }

    func listAdCellDidViewVideo(_ cell: ListADCell) {
        viewModel.trackVideoViewed(cell.ad)
    }
}
