//
//  ProfileAdListViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

protocol ProfileAdListDelegate: AnyObject {
    func scrollViewDidScroll(scrollView: UIScrollView)
}

class ProfileAdListViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyViewPlaceAdButton: UIButton!
    @IBOutlet var emptyViewTitle: UILabel!
    @IBOutlet var emptyViewSubtitle: UILabel!
    @IBOutlet var myWhoppahIcon: UIImageView!
    @IBOutlet var otherUserIcon: UIImageView!
    @IBOutlet var loadingViewContainer: UIView!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listHeadingName: UILabel!
    @IBOutlet var listHeadingSection: UIView!

    var viewModel: ProfileAdListViewModel!
    weak var delegate: ProfileAdListDelegate?
    private var adListVC: AdListViewController!
    private let bag = DisposeBag()
    private var moreItemLoadPage = PublishRelay<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setUpBindings()
        setUpGestures()
        viewModel.loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: IBAction

    @IBAction func postAd(_: UIButton?) {
        postAd()
    }

    @objc func postAdTapped(_: UITapGestureRecognizer) {
        postAd()
    }

    // MARK: Private

    private func setUpGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(postAdTapped(_:)))
        myWhoppahIcon.addGestureRecognizer(tap)
        myWhoppahIcon.isUserInteractionEnabled = false
    }

    private func postAd() {
        viewModel.coordinator.postAd()
    }

    private func setupCollectionView() {
        let vc: AdListViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        vc.emptyView = emptyView
        vc.delegate = self
        addChild(vc)
        listContainer.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leadingAnchor.constraint(equalTo: listContainer.leadingAnchor,
                                         constant: 0).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: listContainer.trailingAnchor,
                                          constant: 0).isActive = true
        vc.view.topAnchor.constraint(equalTo: listContainer.topAnchor,
                                     constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: listContainer.bottomAnchor,
                                        constant: 0).isActive = true

        adListVC = vc

        viewModel.outputs.listAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.adListVC.resultsCollectionView.applyAction(action, pager: self.viewModel.itemsPager)
            }, onError: { [weak self] error in
                self?.showError(error)
            }).disposed(by: bag)
    }

    private func setUpBindings() {
        viewModel.outputs.emptyTitle.bind(to: emptyViewTitle.rx.text).disposed(by: bag)
        viewModel.outputs.emptySubtitle.bind(to: emptyViewSubtitle.rx.text).disposed(by: bag)
        Observable.zip(viewModel.outputs.showEmptySection.map { !$0 }, viewModel.outputs.listHeaderTitle)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] params in
                guard let self = self else { return }
                self.listHeadingSection.isVisible = params.0 && params.1 != nil
                self.listHeadingName.text = params.1
                let topMargin: CGFloat = self.listHeadingSection.isVisible ? 0 : 16
                self.adListVC.resultsCollectionView.contentInset = UIEdgeInsets(top: topMargin, left: 0, bottom: 0, right: 0)
            }).disposed(by: bag)
        viewModel.outputs.showPlaceAdButton.bind(to: emptyViewPlaceAdButton.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showPlaceAdButton.bind(to: myWhoppahIcon.rx.isUserInteractionEnabled).disposed(by: bag)
        viewModel.outputs.showOtherUserIcon.bind(to: otherUserIcon.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showOtherUserIcon.map { !$0 }.bind(to: myWhoppahIcon.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showLoading.bind(to: loadingViewContainer.rx.isVisible).disposed(by: bag)
        viewModel.outputs.showLoading.bind(to: loadingView.rx.isLoading).disposed(by: bag)

        moreItemLoadPage
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 1)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.viewModel.loadMoreItems() {
                    self.adListVC.resultsCollectionView.hideRefreshControls(self.viewModel.itemsPager)
                } else {
                    self.adListVC.resultsCollectionView.showFooterRefreshControl()
                }
            })
            .disposed(by: bag)
    }
}

extension ProfileAdListViewController: SearchListInterface {
    func refetchAds() {
        moreItemLoadPage.accept(1)
        viewModel.loadItems()
    }

    func loadMoreAds() {
        DispatchQueue.main.async {
            self.moreItemLoadPage.accept(self.viewModel.itemsPager.nextPage)
        }
    }

    func didSelectAd(ad: AdViewModel) {
        viewModel.onCellClicked(viewModel: ad)
    }

    func didViewVideo(ad: AdViewModel) {
        viewModel.onVideoViewed(ad: ad)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: scrollView)
    }

    func getNumberOfAds() -> Int {
        viewModel.getNumberOfItems()
    }

    func getAdViewModel(atIndex: Int) -> AdViewModel? {
        viewModel.getCell(atIndex: atIndex)
    }
}
