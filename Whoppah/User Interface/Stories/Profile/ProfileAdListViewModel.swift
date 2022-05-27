//
//  ProfileAdListViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class ProfileAdListViewModel {
    enum ListType {
        case active
        case sold
    }

    var userID: UUID {
        merchant.id
    }

    struct Outputs {
        var error: Observable<Error> {
            _error.asObservable()
        }

        var listAction: Observable<ListAction> {
            _listAction.asObservable()
        }

        fileprivate let _listAction = PublishSubject<ListAction>()
        fileprivate let _error = PublishRelay<Error>()

        let emptyTitle = BehaviorSubject<String>(value: "")
        let emptySubtitle = BehaviorSubject<String>(value: "")
        let listHeaderTitle = BehaviorSubject<String?>(value: nil)
        let showPlaceAdButton = BehaviorSubject<Bool>(value: false)
        let showOtherUserIcon = BehaviorSubject<Bool>(value: false)
        let showEmptySection = BehaviorSubject<Bool>(value: false)
        let showLoading = BehaviorSubject<Bool>(value: true)
    }

    let coordinator: ProfileAdListCoordinator
    let outputs = Outputs()

    private let bag = DisposeBag()
    private let repo: ProfileAdListRepository
    private let merchant: LegacyMerchantOther
    private var ads = [AdViewModel]()
    private var listType = ListType.active
    @Injected private var adService: ADsService
    @Injected private var userService: LegacyUserService
    @Injected private var eventTracking: EventTrackingService

    init(listType: ListType,
         coordinator: ProfileAdListCoordinator,
         repo: ProfileAdListRepository,
         merchant: LegacyMerchantOther) {
        self.coordinator = coordinator
        self.listType = listType
        self.merchant = merchant
        self.repo = repo

        let isCurrent = isCurrentUser()
        if isCurrent {
            outputs.emptyTitle.onNext(R.string.localizable.main_my_profile_current_user_no_adverts_title())
            outputs.emptySubtitle.onNext(R.string.localizable.main_my_profile_current_user_place_ad_title())
        } else {
            outputs.emptyTitle.onNext(R.string.localizable.main_my_profile_no_adverts_title())
            outputs.emptySubtitle.onNext(R.string.localizable.main_my_profile_user_no_active_ads_title())
        }
        outputs.showLoading.onNext(true)
        outputs.showPlaceAdButton.onNext(false)
        outputs.showOtherUserIcon.onNext(!isCurrent)

        // Skip the first so we don't get the first empty list
        _ = repo.productRepo.items.skip(1).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(products):
                let initialCount = repo.productRepo.numitems()

                var indexPaths = [IndexPath]()
                for index in products.elements.indices {
                    indexPaths.append(IndexPath(row: initialCount + index, section: 0))
                }

                if repo.productRepo.pager.currentPage > 1 {
                    // self.trackRandomAdScroll()
                }
                self.outputs.showLoading.onNext(false)
                // Only set when there are items
                self.outputs.showPlaceAdButton.onNext(isCurrent && repo.productRepo.numitems() == 0)
                self.outputs.listHeaderTitle.onNext(self.listHeaderText())
                self.outputs.showEmptySection.onNext(repo.productRepo.numitems() == 0)
                self.outputs._listAction.onNext(.newRows(rows: indexPaths,
                                                         updater: ProductsRepoUpdater(items: products.elements, repo: self.repo.productRepo)))
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.outputs._listAction.onError(error)
        }).disposed(by: bag)
    }

    private func loadAds() {
        let userId = merchant.id
        switch listType {
        case .active:
            repo.productRepo.load(id: userId, auctionState: .published, productState: nil)
        case .sold:
            repo.productRepo.load(id: userId, auctionState: .completed, productState: nil)
        }
    }

    private func isCurrentUser() -> Bool {
        merchant.id == userService.current?.merchantId
    }

    private func listHeaderText() -> String? {
        let name = getMerchantDisplayName(type: merchant.type, businessName: merchant.businessName, name: merchant.name)
        return R.string.localizable.main_my_profile_my_ads_seller_title(name).localizedUppercase
    }
}

// MARK: Datasource

extension ProfileAdListViewModel {
    func loadItems() {
        let reload = repo.productRepo.numitems() > 0
        loadAds()
        // If we don't reload the list here we get a crash
        // Because we append new items to the list, if there's some already in the list we crash
        if reload {
            outputs._listAction.onNext(.reloadAll)
        }
    }

    func loadMoreItems() -> Bool {
        let hasMore = repo.productRepo.loadMore()
        if !hasMore {
            outputs._listAction.onNext(.endRefresh)
        }
        return hasMore
    }

    var itemsPager: PagedView {
        repo.productRepo.pager
    }

    func getNumberOfItems() -> Int {
        repo.productRepo.numitems()
    }

    func getCell(atIndex index: Int) -> AdViewModel? {
        repo.productRepo.getViewModel(atIndex: index)
    }

    func onCellClicked(viewModel: AdViewModel) {
        coordinator.openAd(viewModel: viewModel)
    }
}

extension ProfileAdListViewModel {
    func onVideoViewed(ad: AdViewModel) {
        eventTracking.trackVideoViewed(ad: ad.product, isFullScreen: true, page: .profile)
    }
}
