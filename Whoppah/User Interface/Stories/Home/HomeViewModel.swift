//
//  HomeVIewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 23/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver

class HomeViewModel {
    @Injected private var crashReporter: CrashReporter
    
    private let repository: HomeRepository
    private let coordinator: HomeCoordinator
    @Injected private var eventTracking: EventTrackingService
    @Injected private var search: SearchService
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var location: LocationService
    @Injected private var storeService: StoreService
    private var checkedUpdate: Bool = false

    // Categories
    var categoryList = BehaviorSubject<ListAction>(value: .initial)
    var categories = [CircleImageCellViewModel]()

    // More items
    var randomList = PublishSubject<ListAction>()
    var randomListPresentationMode = ListPresentation.grid {
        didSet {
            randomList.onNext(.changePresentation(style: randomListPresentationMode))
        }
    }

    private var blocksubject = PublishSubject<BlockViewModel?>()
    var blocks: Driver<BlockViewModel?> {
        blocksubject.asDriver(onErrorJustReturn: nil)
    }

    private let categoryBag = DisposeBag()
    private var bag = DisposeBag()

    init(repository: HomeRepository, coordinator: HomeCoordinator) {
        self.repository = repository
        self.coordinator = coordinator

        repository.categoryRepo.categories.drive(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(categoryList):
                guard let categories = categoryList?.categories else { return }
                self.categories.removeAll()
                for category in categories.items {
                    let url = URL(string: category.image.first?.url ?? "")
                    self.categories.append(CircleImageCellViewModel(title: category.title, url: url, slug: category.slug))
                }

                self.categoryList.onNext(.reloadAll)
            case let .failure(error):
                self.crashReporter.log(error: error)
                self.coordinator.showError(error)
            }
        }).disposed(by: categoryBag) // Loaded only once so don't want to re-register

        loadCategories()
        loadUser()
    }

    func reloadAll() {
        bag = DisposeBag()
        // Random Items
        _ = repository.moreItemRepo.items.subscribe(onNext: { [weak self] products in
            guard let self = self else { return }
            switch products {
            case let .success(products):
                let initialCount = self.repository.moreItemRepo.numitems()

                var indexPaths = [IndexPath]()
                for index in products.elements.indices {
                    indexPaths.append(IndexPath(row: initialCount + index, section: 0))
                }

                if self.repository.moreItemRepo.pager.currentPage > 1 {
                    self.trackRandomAdScroll()
                }
                self.randomList.onNext(.newRows(rows: indexPaths,
                                                updater: SearchRepoUpdater(items: products.elements, repo: self.repository.moreItemRepo)))
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.crashReporter.log(error: error)
            self.coordinator.showError(error)
        }).disposed(by: bag)

        // Home block
        repository.homeBlock.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }

            guard let blocks = data?.pageByKey?.blocks else { return }
            for block in blocks {
                if let textParts = block.asTextBlock {
                    guard textParts.slug != "usp" else { continue }
                    self.blocksubject.onNext(TextBlockViewModel(block: textParts))
                } else if let productParts = block.asProductBlock {
                    guard !productParts.blockProducts.isEmpty else { continue }
                    let model = ProductBlockViewModel(block: productParts)
                    model.productClick.subscribe { [weak self] model in
                        guard let product = model.element else { return }
                        self?.open(product: product)
                    }.disposed(by: self.bag)
                    model.showAllClick.subscribe { [weak self] block in
                        guard let block = block.element else { return }
                        self?.onShowAllClicked(block)
                    }.disposed(by: self.bag)
                    self.blocksubject.onNext(model)
                } else if let attributeParts = block.asAttributeBlock {
                    guard !attributeParts.attributes.isEmpty else { continue }
                    let model = AttributeBlockViewModel(block: attributeParts)
                    model.outputs.sectionClicked.subscribe(onNext: { [weak self] attribute in
                        self?.open(attribute: attribute)
                    }).disposed(by: self.bag)
                    self.blocksubject.onNext(model)
                } else if let merchantParts = block.asMerchantBlock {
                    guard !merchantParts.merchants.isEmpty else { continue }
                    let model = AttributeBlockViewModel(block: merchantParts)
                    model.outputs.sectionClicked.subscribe(onNext: { [weak self] merchant in
                        self?.open(merchant: merchant.id)
                    }).disposed(by: self.bag)
                    self.blocksubject.onNext(model)
                } else if let categoryParts = block.asCategoryBlock {
                    guard !categoryParts.categories.isEmpty else { continue }
                    let model = AttributeBlockViewModel(block: categoryParts)
                    model.outputs.sectionClicked.subscribe(onNext: { [weak self] category in
                        self?.open(attribute: category)
                    }).disposed(by: self.bag)
                    self.blocksubject.onNext(model)
                }
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.crashReporter.log(error: error)
            self.coordinator.showError(error)
        }).disposed(by: bag)

        repository.loadHomeblock()
        loadRandomItems()
    }

    func uspTapped(blockName: String) {
        eventTracking.home.trackClickedUSPBanner(blockName: blockName)
        coordinator.openSafeShopping()
    }

    func openMap() {
        let defaultAddress = user.current?.mainMerchant.address.first
        guard let userAddress = defaultAddress else {
            coordinator.askLocation { [weak self] address in
                guard let self = self else { return }
                self.search.address = address

                if let point = address.point {
                    let coordinates = point.coordinate
                    self.coordinator.openMap(latitude: coordinates.latitude, longitude: coordinates.longitude)
                }
            }
            return
        }

        coordinator.openMap(latitude: userAddress.point?.coordinate.latitude,
                            longitude: userAddress.point?.coordinate.longitude)
    }

    func didViewVideo(ad: AdViewModel) {
        trackVideoView(ad: ad.product)
    }

    func checkForAppUpdates() {
        storeService.checkForUpdate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                DispatchQueue.main.async {
                    switch result {
                    case .blocking, .nonBlocking:
                        self.coordinator.openUpdateAppDialog(result)
                    case .none:
                        guard !self.checkedUpdate else { return }
                        // Push towards sign up/logging in, we don't care about full profiles at this point
                        // And if there's no deep links pending to be processed
                        if !DeeplinkManager.shared.hasPendingDeepLink() {
                            self.coordinator.openLoginSplash()
                        }
                    }
                }
            case .failure:
                guard !self.checkedUpdate else { return }
                DispatchQueue.main.async {
                    // Push towards sign up/logging in, we don't care about full profiles at this point
                    // And if there's no deep links pending to be processed
                    if !DeeplinkManager.shared.hasPendingDeepLink() {
                        self.coordinator.openLoginSplash()
                    }
                }
            }
            self.checkedUpdate = true
        }
    }

    // MARK: Privates

    private func open(product: WhoppahCore.Product) {
        coordinator.openAdDetails(adID: product.id)
        trackAdOpened(product: product)
    }
    
    private func open(merchant: UUID) {
        Navigator().navigate(route: Navigator.Route.userProfile(id: merchant))
    }

    private func open(attribute: BlockDataSource) {
        guard let filter = attribute.filter?.toNewModel else { return }
        
        search.removeAllFilters()
        Navigator().navigate(route: Navigator.Route.search(input: .init(filters: [filter])))
    }

    private func loadUser() {
        guard user.isLoggedIn else { return }
        user.getActive()
    }

    private func openLink(_ url: URL) {
        search.removeAllFilters()
        if DeeplinkManager.shared.handleDeeplink(url: url) {
            DeeplinkManager.shared.executeDeeplink()
        }
    }
}

// MARK: Categories

extension HomeViewModel {
    func onCategoryClicked(row: Int) {
        assert(row < categories.count)
        let category = categories[row]
        category.title
            .compactMap { $0 }
            .take(1)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.search.removeAllFilters()
                self.search.categories.insert(FilterAttribute(type: .category, slug: category.slug, title: title, children: nil))
                self.coordinator.openSearch(input: .init(filters: [.init(key: .category, value: category.slug)]))

                self.eventTracking.home.trackCategoryClicked(category: title)
        }).disposed(by: bag)
    }

    func getCategoryCell(row: Int) -> CircleImageCellViewModel {
        assert(row < categories.count)
        return categories[row]
    }

    private func loadCategories() {
        categoryList.onNext(.loadingInitial)
        repository.categoryRepo.load(level: 0)
    }
}

extension HomeViewModel {
    func onShowAllClicked(_ block: ProductBlock) {
        guard let link = block.link, let url = URL(string: link) else { return }
        openLink(url)
    }
}

// MARK: Random items

extension HomeViewModel {
    private func loadRandomItems() {
        let reload = repository.moreItemRepo.numitems() > 0
        repository.moreItemRepo.load(query: nil, filter: nil, sort: nil, ordering: nil)
        // If we don't reload the list here we get a crash
        // Because we append new items to the list, if there's some already in the list we crash
        if reload {
            randomList.onNext(.reloadAll)
        }
    }

    func loadMoreRandomItems() -> Bool {
        let hasMore = repository.moreItemRepo.loadMore()
        if !hasMore {
            randomList.onNext(.endRefresh)
        }
        return hasMore
    }

    var randomItemsPager: PagedView {
        repository.moreItemRepo.pager
    }

    func getNumberOfRandomItems() -> Int {
        repository.moreItemRepo.numitems()
    }

    func getRandomCell(row: Int) -> AdViewModel {
        repository.moreItemRepo.getViewModel(atIndex: row)!
    }

    func onRandomCellClicked(row: Int) {
        guard let viewModel = repository.moreItemRepo.getViewModel(atIndex: row) else { return }
        open(product: viewModel.product)
    }

    func changeMoreItemsPresentation(_ style: ListPresentation) {
        eventTracking.trackListStyleClicked(style: style, page: .home)
        randomListPresentationMode = style
    }
}

// MARK: Analytics

extension HomeViewModel {
    func trackAdOpened(product: WhoppahCore.Product) {
        eventTracking.trackClickProduct(ad: product, page: .home)
    }

    func trackVideoView(ad: WhoppahCore.Product) {
        eventTracking.trackVideoViewed(ad: ad, isFullScreen: false, page: .home)
    }

    func trackRandomAdScroll() {
        eventTracking.home.trackRandomScrolled(scrollDepth: repository.moreItemRepo.pager.currentDepth)
    }
}
