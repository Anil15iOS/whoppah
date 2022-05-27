//
//  HomeViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/2/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import MapKit
import RxCocoa
import RxSwift
import SkeletonView
import UIKit
import WhoppahCoreNext
import Resolver
import WhoppahCore

class HomeViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var rootView: UIView?
    @IBOutlet var categoriesCollectionView: UICollectionView!

    @IBOutlet var sellView: UIView!
    @IBOutlet var sellButton: UIButton!
    @IBOutlet var uspView: UIView!
    @IBOutlet var uspButton: UIButton!

    @IBOutlet var mapBannerView: UIView!

    private var homeBlocks = [UIView]()
    @IBOutlet var listContainer: UIStackView!
    @IBOutlet var loadingView: UIView?

    @IBOutlet var moreItemsCollectionView: UICollectionView!
    @IBOutlet var moreItemsPresentationChangeButton: UIButton!
    private var moreItemLoadPage = PublishRelay<Int>()
    private let blockInset = UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)

    // MARK: - Properties

    var viewModel: HomeViewModel!
    var coordinator: HomeCoordinator!
    private var bag = DisposeBag()
    private var howItWorksButtonDisposable: Disposable?

    let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3
    
    @LazyInjected private var userProvider: UserProviding

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpBanners()
        loadCategories()
        loadRandomItems()
        setUpBlocks()
        reloadAll()
    }

    func reloadAll() {
        loadingView?.showAnimatedGradientSkeleton()
        // Remove existing blocks
        homeBlocks.forEach { $0.removeFromSuperview() }
        moreItemLoadPage.accept(1)
        homeBlocks.removeAll()
        loadingView?.isVisible = true
        moreItemsCollectionView.isScrollEnabled = true
        viewModel.reloadAll()
        viewModel.checkForAppUpdates()
    }

    func scrollToTop() {
        if isViewLoaded {
            moreItemsCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let loading = loadingView, loading.isVisible {
            loading.layoutSkeletonIfNeeded()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        moreItemsCollectionView.collectionViewLayout.invalidateLayout()
        homeBlocks.forEach { ($0 as? HomeBlock)?.collectionView.collectionViewLayout.invalidateLayout() }
    }

    // MARK: - Private

    private func setUpBlocks() {
        viewModel.blocks.drive(onNext: { model in
            guard let model = model else { return }
            if let homeModel = model as? ProductBlockViewModel {
                // Create a block of products :)
                let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
                let homeBlock = HomeBlock(frame: frame)
                homeBlock.delegate = self
                homeBlock.viewModel = homeModel
                // homeBlock.translatesAutoresizingMaskIntoConstraints = false
                self.listContainer.addArrangedSubview(homeBlock)
                homeBlock.leadingAnchor.constraint(equalTo: self.listContainer.leadingAnchor,
                                                   constant: 0).isActive = true
                homeBlock.trailingAnchor.constraint(equalTo: self.listContainer.trailingAnchor,
                                                    constant: 0).isActive = true
                self.homeBlocks.append(homeBlock)
            } else if let textBlock = model as? TextBlockViewModel {
                switch textBlock.blockType {
                case .map:
                    self.mapBannerView.isHidden = false
                    self.listContainer.removeArrangedSubview(self.mapBannerView)
                    self.listContainer.addArrangedSubview(self.mapBannerView)
                    self.mapBannerView.pinToEdges(of: self.listContainer, orientation: .horizontal)
                    self.homeBlocks.append(self.mapBannerView)
                case .cartButton:
                    self.sellView.isHidden = false
                    self.sellButton.rx.tap.subscribe(onNext: {
                        textBlock.didClickButton()
                    }).disposed(by: self.bag)
                case .howWorksButton:
                    self.uspView.isHidden = false
                    self.howItWorksButtonDisposable?.dispose()
                    self.howItWorksButtonDisposable = self.uspButton.rx.tap.subscribe(onNext: {
                        textBlock.didClickButton()
                    })
                case .unknown:
                    let block = self.getTextBlockView(viewModel: textBlock)
                    self.homeBlocks.append(block)
                }
            } else if let attributeBlock = model as? AttributeBlockViewModel {
                let block = self.getAttributeBlockView(viewModel: attributeBlock)
                self.homeBlocks.append(block)
            }

            // If we don't call this layout the height of the header is incorrectly determined
            self.rootView!.layoutIfNeeded()
            // Enable scrolling again
            self.moreItemsCollectionView.isScrollEnabled = true
            // Ask the collection view to refresh the header reference height
            self.moreItemsCollectionView.collectionViewLayout.invalidateLayout()
            self.loadingView?.isVisible = false
            self.loadingView?.hideSkeleton()

        }).disposed(by: bag)
    }

    private func getTextBlockView(viewModel: TextBlockViewModel) -> UIView {
        let block = TextBlockView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        block.configure(withBlock: viewModel)

        block.carousel?.scrolling
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isScrolling in
                self?.moreItemsCollectionView.isScrollEnabled = !isScrolling
            }).disposed(by: bag)

        block.translatesAutoresizingMaskIntoConstraints = false
        listContainer.addArrangedSubview(block)
        block.leadingAnchor.constraint(equalTo: listContainer.leadingAnchor,
                                       constant: 0).isActive = true
        block.widthAnchor.constraint(equalTo: listContainer.widthAnchor,
                                     constant: 0).isActive = true
        let aspect: CGFloat = viewModel.style == .type1 ? 0.66 : 0.8387
        block.addConstraint(NSLayoutConstraint(item: block,
                                               attribute: NSLayoutConstraint.Attribute.height,
                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                               toItem: block,
                                               attribute: NSLayoutConstraint.Attribute.width,
                                               multiplier: aspect,
                                               constant: 0))

        return block
    }

    private func getAttributeBlockView(viewModel: AttributeBlockViewModel) -> UIView {
        var newView: UIView?
        switch viewModel.style {
        case .carousel:
            let attributeView = AttributeBlockView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
            attributeView.configure(withVM: viewModel)
            newView = attributeView
        case .grid:
            let attributeGridView = AttributeGridView(viewModel: viewModel)
            newView = attributeGridView
        case .horizontalList:
            let horizontalView = HorizontalScrollableList(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
            horizontalView.configure(withVM: viewModel)
            newView = horizontalView
        }
        guard let view = newView else { return UIView() }
        view.translatesAutoresizingMaskIntoConstraints = false
        listContainer.addArrangedSubview(view)
        view.leadingAnchor.constraint(equalTo: listContainer.leadingAnchor,
                                      constant: 0).isActive = true
        view.widthAnchor.constraint(equalTo: listContainer.widthAnchor,
                                    constant: 0).isActive = true
        // The carousel style needs an explicit size
        // The horizontal list will size itself
        guard viewModel.style == .carousel else { return view}
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: view,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              multiplier: 0.672,
                                              constant: 0))
        return view
    }

    private func setUpCollectionView() {
        categoriesCollectionView.register(UINib(nibName: CircleImageCell.nibName, bundle: nil), forCellWithReuseIdentifier: CircleImageCell.identifier)
        
        moreItemsCollectionView.register(UINib(nibName: GridADCell.nibName, bundle: nil), forCellWithReuseIdentifier: GridADCell.identifier)
        moreItemsCollectionView.register(UINib(nibName: ListADCell.nibName, bundle: nil), forCellWithReuseIdentifier: ListADCell.identifier)
        moreItemsCollectionView.register(UINib(nibName: HomeHeader.nibName, bundle: nil),
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: HomeHeader.identifier)
        moreItemsCollectionView.bindFootRefreshHandler({}, themeColor: UIColor.orange, refreshStyle: .native)
        
        rootView!.isVisible = false
        rootView!.removeFromSuperview()
        rootView!.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setUpBanners() {
        let tapGesture = UITapGestureRecognizer()
        mapBannerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.viewModel.openMap()
        }).disposed(by: bag)
    }

    private func loadCategories() {
        // Ideally we'd use the nice Rx items feature but we can't
        // Skeletons are not yet supported in this system and so make it difficult to adopt
        sellView.showAnimatedGradientSkeleton()
        uspView.showAnimatedGradientSkeleton()
        viewModel.categoryList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.categoriesCollectionView.applyAction(action, pager: nil)
                self.sellView.hideSkeleton()
                self.uspView.hideSkeleton()
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    private func loadRandomItems() {
        viewModel.randomList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.moreItemsCollectionView.applyAction(action, pager: self.viewModel.randomItemsPager)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        moreItemLoadPage
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.loadMoreRandomItems() {
                    self.moreItemsCollectionView.showFooterRefreshControl()
                }
            })
            .disposed(by: bag)
    }

    private func likeAd(_ ad: AdViewModel) {
        guard userProvider.isLoggedIn else {
            getTabsVC()?.openContextualSignupIfNeeded(title: R.string.localizable.contextualSignupFavoritesTitle(),
                                                      description: R.string.localizable.contextualSignupFavoritesDescription())
            return
        }

        let observer = ad.toggleLikeStatus()
        observer
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
        observer.connect().disposed(by: bag)
    }

    // MARK: - Actions

    @IBAction func changeMoreItemsPresentation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.changeMoreItemsPresentation(sender.isSelected ? ListPresentation.list : ListPresentation.grid)
    }
}

extension HomeViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        switch collectionSkeletonView {
        case categoriesCollectionView, moreItemsCollectionView:
            return 1
        default:
            assertionFailure("Missing cell")
            return 1
        }
    }

    func collectionSkeletonView(_: UICollectionView, supplementaryViewIdentifierOfKind: String, at _: IndexPath) -> ReusableCellIdentifier? {
        guard supplementaryViewIdentifierOfKind == UICollectionView.elementKindSectionHeader else {
            return nil
        }
        return HomeHeader.identifier
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        switch skeletonView {
        case categoriesCollectionView:
            return 6
        case moreItemsCollectionView:
            return 25
        default:
            assertionFailure("Missing cell")
            return 0
        }
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case categoriesCollectionView:
            return CircleImageCell.identifier
        case moreItemsCollectionView:
            return GridADCell.identifier
        default:
            assertionFailure("Missing cell")
            return ""
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        switch collectionView {
        case moreItemsCollectionView:
            guard let view = rootView else { return .zero }
            let rootHeight = view.frame.height
            let cvWidth = moreItemsCollectionView.bounds.width
            return CGSize(width: cvWidth, height: rootHeight)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind _: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case moreItemsCollectionView:
            let headerView = moreItemsCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeader.identifier, for: indexPath)
            guard let root = rootView else { return UICollectionReusableView() }
            root.removeFromSuperview()
            root.isVisible = true
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(root)
            root.center(withView: headerView, orientation: .horizontal)
            headerView.setEqualsSize(toView: view, orientation: .horizontal)
            root.setEqualsSize(toView: view, orientation: .horizontal)
            root.pinToEdges(of: headerView, orientation: .vertical)
            return headerView
        default:
            break
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        switch collectionView {
        case categoriesCollectionView:
            return viewModel.categories.count
        case moreItemsCollectionView:
            return viewModel.getNumberOfRandomItems()
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleImageCell.identifier, for: indexPath) as! CircleImageCell
            cell.hideSkeleton()
            cell.configure(with: viewModel.getCategoryCell(row: indexPath.row))
            return cell
        case moreItemsCollectionView:
            guard viewModel.randomListPresentationMode == .list else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridADCell.identifier, for: indexPath) as! GridADCell
                cell.configure(withVM: viewModel.getRandomCell(row: indexPath.row))
                cell.delegate = self
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListADCell.identifier, for: indexPath) as! ListADCell
            cell.configure(withVM: viewModel.getRandomCell(row: indexPath.row))
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoriesCollectionView:
            viewModel.onCategoryClicked(row: indexPath.row)
        case moreItemsCollectionView:
            viewModel.onRandomCellClicked(row: indexPath.row)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case moreItemsCollectionView:
            if collectionView.needsLoadsMore(presentation: viewModel.randomListPresentationMode,
                                             row: indexPath.row,
                                             totalItems: viewModel.getNumberOfRandomItems(),
                                             numsColums: listNumCols) {
                DispatchQueue.main.async {
                    self.moreItemLoadPage.accept(self.viewModel.randomItemsPager.nextPage)
                }
            }
        default:
            break
        }
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let cell = cell as? GridADCell {
            cell.stopVideo()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let inset = blockInset
        // The view here is used instead of the collection view
        // This is because the viewDidLayoutSubviews reports a lower value here than the screen value (constraints not updated yet?)
        let cvWidth = view.frame.width
        let availableWidth = cvWidth - inset.left - inset.right
        switch cv {
        case categoriesCollectionView:
            var itemSize = 91
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
        case moreItemsCollectionView:
            guard viewModel.randomListPresentationMode == .list else { return getGridItemSize() }
            return CGSize(width: cv.bounds.width - 32.0, height: cv.bounds.width - 32 + 58)
        default:
            return .zero
        }
    }

    private func getGridItemSize() -> CGSize {
        let availableWidth = view.frame.width - blockInset.left - blockInset.right
        let width = availableWidth - (UIConstants.listInteritemHSpacing * CGFloat(listNumCols - 1))
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * GridADCell.aspect
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        switch collectionView {
        case categoriesCollectionView:
            return UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
        case moreItemsCollectionView:
            return UIEdgeInsets(top: 0, left: UIConstants.margin, bottom: 0, right: UIConstants.margin)
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case categoriesCollectionView:
            return 8.0
        case moreItemsCollectionView:
            return UIConstants.listInteritemHSpacing
        default:
            return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        switch collectionView {
        case categoriesCollectionView:
            return 0.0
        case moreItemsCollectionView:
            return UIConstants.listInteritemVSpacing
        default:
            return 0.0
        }
    }
}

// MARK: - GridADCellDelegate

extension HomeViewController: GridADCellDelegate {
    func gridAdCell(_ cell: GridADCell, didClickLike _: RoundedButton) {
        likeAd(cell.ad)
    }

    func gridAdCellDidViewVideo(_ cell: GridADCell) {
        viewModel.didViewVideo(ad: cell.ad)
    }
}

// MARK: - ListADCellDelegate

extension HomeViewController: ListADCellDelegate {
    func listAdCell(_ cell: ListADCell, didClickLike _: UIButton) {
        likeAd(cell.ad)
    }

    func listAdCellDidViewVideo(_ cell: ListADCell) {
        viewModel.didViewVideo(ad: cell.ad)
    }
}
