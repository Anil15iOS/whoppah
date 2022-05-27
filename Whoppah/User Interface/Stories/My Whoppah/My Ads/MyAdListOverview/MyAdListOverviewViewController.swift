//
//  AdListOverviewViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCoreNext
import Resolver

class MyAdListOverviewViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var collectionView: UICollectionView!

    // MARK: Properties

    var viewModel: MyAdListOverviewViewModel!
    private let bag = DisposeBag()
    private let listNumCols = UIDevice.current.userInterfaceIdiom != .pad ? 2 : 3
    private var data: [AdOverviewCellData] = []
    
    @Injected fileprivate var crashReporter: CrashReporter
    @Injected fileprivate var inAppNotifier: InAppNotifier
    @Injected fileprivate var adCreator: ADCreator

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setupCollectionView()
        setUpBindings()
        refetchAds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We may have had one item in the list and it was deleted in a subVC
        viewModel.numItems == 0 ? dismiss(animated: true, completion: nil) : collectionView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        viewModel.outputs.title.bind(to: navigationBar.titleLabel.rx.text).disposed(by: bag)
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: MyAdOverviewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: MyAdOverviewCell.identifier)
        collectionView.register(MyAdOverviewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MyAdOverviewHeader.identifier)

        collectionView.bindHeadRefreshHandler({ self.refetchAds() }, themeColor: UIColor.orange, refreshStyle: .native)
        collectionView.bindFootRefreshHandler(nil, themeColor: UIColor.orange, refreshStyle: .native)
    }

    private func setUpBindings() {
        viewModel.outputs.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)

        viewModel.outputs.ads.subscribe(onNext: { [weak self] data in
            self?.data = data
            self?.collectionView.reloadData()
        }, onError: { [weak self] error in
            self?.showError(error)
        }).disposed(by: bag)
    }

    private func dismissVC() {
        if let navVC = navigationController {
            navVC.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func refetchAds() {
        viewModel.reloadAds()
    }

    private func loadMoreAds() {
        guard viewModel.loadMoreAds() else {
            collectionView.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
            return
        }

        collectionView.showFooterRefreshControl()
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        dismissVC()
    }
}

extension MyAdListOverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAdOverviewCell.identifier, for: indexPath) as! MyAdOverviewCell
        cell.configure(withData: data[indexPath.row])
        cell.delegate = self
        self.collectionView.hideRefreshControls(nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let tabsVC = getTabsVC() else { return }

        let myadVC: MyAdStatisticsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        myadVC.viewModel = MyAdStatisticsViewModel(withID: data[indexPath.row].ID,
                                                   repo: MyAdStatisticsRepositoryImpl())

        tabsVC.navigationController?.pushViewController(myadVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind _: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: MyAdOverviewHeader.identifier,
                                                                     for: indexPath) as! MyAdOverviewHeader
        viewModel.outputs.subtitle.bind(to: header.titleLabel.rx.text).disposed(by: bag)
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        referenceSizeForHeaderInSection _: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 60)
    }

    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView(cv, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        // The view here is used instead of the collection view
        // This is because the viewDidLayoutSubviews reports a lower value here than the screen value (constraints not updated yet?)
        let cvWidth = view.frame.width
        let availableWidth = cvWidth - inset.left - inset.right
        let interitemSpacing = collectionView(cv, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section) * CGFloat(listNumCols - 1)
        let width = availableWidth - interitemSpacing
        let itemWidth = width / CGFloat(listNumCols)
        let itemHeight = itemWidth * GridADCell.aspect
        return CGSize(width: itemWidth, height: itemHeight)
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

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numItems - 5 {
            DispatchQueue.main.async {
                self.loadMoreAds()
            }
        }
    }
}

extension MyAdListOverviewViewController: MyAdOverviewDelegate {
    func didSelectEdit(cell: MyAdOverviewCell) {
        guard let adID = cell.data?.ID else { return }

        viewModel!.getAdDetails(adID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(template):
                let vc = self.getEditAdVC(template, adCreator: self.adCreator)
                self.present(vc, animated: true, completion: nil)
            case let .failure(error):
                self.showError(error)
            }
        }
    }

    func didSelectDelete(cell: MyAdOverviewCell) {
        guard let ID = cell.data?.ID else { return }
        if viewModel.showDeleteDialog(ID) {
            let deleteDialog = DeleteAnADDialog()
            crashReporter.log(event: "Deleting ad with ID: \(ID)", withInfo: nil)

            deleteDialog.callback = { deleteSelected, reason in
                guard let ID = cell.data?.ID, let reason = reason else { return }
                if deleteSelected {
                    self.viewModel?.deleteAd(ID, reason: reason).subscribe(onNext: { [weak self] in
                        self?.crashReporter.log(event: "Deleted ad with ID: \(ID)", withInfo: nil)
                        self?.onAdDeleted(cell: cell)
                    }, onError: { [weak self] error in
                        self?.showError(error)
                    }).disposed(by: self.bag)
                }
            }
            present(deleteDialog, animated: true, completion: nil)
        } else {
            guard let id = cell.data?.ID else { return }
            viewModel?.deleteAd(id, reason: nil).subscribe(onNext: { [weak self] in
                self?.crashReporter.log(event: "Deleted ad with ID: \(id)", withInfo: nil)
                self?.onAdDeleted(cell: cell)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
        }
    }

    func onAdDeleted(cell: MyAdOverviewCell) {
        let adDeletedDialog = AdDeletedDialog()
        present(adDeletedDialog, animated: true, completion: nil)
        if let indexPath = collectionView.indexPath(for: cell) {
            if viewModel.numItems == 0 {
                dismissVC()
            } else {
                collectionView.performBatchUpdates({ collectionView.deleteItems(at: [indexPath]) })
            }
        }
    }

    private func onAdReposted(_ cell: MyAdOverviewCell, id: UUID) {
        if cell.data?.ID == id {
            inAppNotifier.notify(.adReposted, userInfo: ["id": id])

            if let indexPath = collectionView.indexPath(for: cell) {
                if viewModel.numItems == 0 {
                    dismissVC()
                } else {
                    collectionView.performBatchUpdates({ collectionView.deleteItems(at: [indexPath]) })
                }
            }
        }
    }

    func didSelectRepost(cell: MyAdOverviewCell) {
        let title = R.string.localizable.repost_ad_dialog_title().localizedUppercase
        let dialog = YesNoDialog.create(withMessage: R.string.localizable.repost_ad_dialog_body(), andTitle: title) { [weak self] result in
            guard let self = self else { return }
            if result == .yes {
                if let id = cell.data?.ID, let auctionId = cell.data?.auctionId {
                    self.viewModel.repostAd(auctionId, id: id)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] _ in
                            self?.onAdReposted(cell, id: id)
                        }, onError: { [weak self] error in
                            self?.showError(error)
                        }).disposed(by: self.bag)
                }
            }
        }
        present(dialog, animated: true, completion: nil)
    }
}
