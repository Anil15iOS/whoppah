//
//  FavoritesViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver

class FavoritesViewModel {
    private let coordinator: FavoritesCoordinator
    private let repo: FavoritesRepository
    private let bag = DisposeBag()
    var favoriteList = PublishSubject<ListAction>()
    var favoriteListPresentationMode = ListPresentation.grid {
        didSet {
            favoriteList.onNext(.changePresentation(style: favoriteListPresentationMode))
        }
    }

    struct Outputs {
        let recommendedItems = BehaviorSubject<[AdViewModel]>(value: [])
        let showLoading = BehaviorSubject<Bool>(value: true)
    }
    
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected private var eventTrackingService: EventTrackingService

    let outputs = Outputs()

    init(coordinator: FavoritesCoordinator,
         repo: FavoritesRepository) {
        self.coordinator = coordinator
        self.repo = repo
        
        repo.items.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.favoriteList.onNext(.reloadAll)
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }).disposed(by: bag)

        repo.recommendedItems.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(ads):
                self.outputs.recommendedItems.onNext(ads)
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }).disposed(by: bag)

        repo.items.skip(1).asObservable()
            .map { _ in false }
            .bind(to: outputs.showLoading)
            .disposed(by: bag)
    }

    func loadFavoriteItems() {
        guard let id = userService.current?.merchantId else { return }
        let reload = repo.numitems() > 0
        outputs.showLoading.onNext(true)
        repo.load(id: id)
        // If we don't reload the list here we get a crash
        // Because we append new items to the list, if there's some already in the list we crash
        if reload {
            favoriteList.onNext(.reloadAll)
        }
    }

    func loadMoreFavoriteItems() -> Bool {
        // Not supported
        favoriteList.onNext(.endRefresh)
        return false
    }

    var favoriteItemsPager: PagedView {
        repo.pager
    }

    func getNumberOfFavoriteItems() -> Int {
        repo.numitems()
    }

    func getFavoriteCell(row: Int) -> AdViewModel {
        repo.getViewModel(atIndex: row)!
    }

    func changeFavoriteItemsPresentation(_ style: ListPresentation) {
        eventTrackingService.trackListStyleClicked(style: style, page: .favorites)
        favoriteListPresentationMode = style
    }

    func favoriteSelected(_ row: Int) {
        guard let vm = repo.getViewModel(atIndex: row) else { return }
        coordinator.openAd(vm)
        eventTrackingService.trackClickProduct(ad: vm.product, page: .favorites)
    }
}

extension FavoritesViewModel {
    func likeAd(_ vm: AdViewModel) {
        let observer = vm.toggleLikeStatus()
        observer
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.repo.onAdLiked(viewModel: vm)
                } else {
                    self.repo.onAdUnliked(viewModel: vm)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.coordinator.showError(error)
            }).disposed(by: bag)
        observer.connect().disposed(by: bag)
    }
}

extension FavoritesViewModel {
    func loadRecommendedItems() {
        guard let currentUser = userService.current?.id else { return }
        repo.loadRecommendedItems(id: currentUser)
    }

    func recommendedItemSelected(ad: AdViewModel) {
        coordinator.openAd(ad)
        trackProductClick(ad)
    }
}

extension FavoritesViewModel {
    func trackVideoViewed(_ vm: AdViewModel) {
        eventTrackingService.trackVideoViewed(ad: vm.product, isFullScreen: false, page: .favorites)
    }

    func trackProductClick(_ vm: AdViewModel) {
        eventTrackingService.trackClickProduct(ad: vm.product, page: .favorites)
    }
}
