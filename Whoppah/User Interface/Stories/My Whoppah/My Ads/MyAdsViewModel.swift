//
//  MyAdsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver

class MyAdsViewModel {
    private let activeRepo: MyAdListRepository
    private let curatedRepo: MyAdListRepository
    private let draftsRepo: MyAdListRepository
    private let rejectedRepo: MyAdListRepository
    private let repos: [MyAdListRepository]
    private let productRepo: LegacyProductDetailsRepository
    private let soldRepo: OrderRepository
    private let bag = DisposeBag()

    struct Outputs {
        var activeList = PublishSubject<(totalCount: Int, elements: [AdViewModel])>()
        var rejectedList = PublishSubject<(totalCount: Int, elements: [AdViewModel])>()
        var draftList = PublishSubject<(totalCount: Int, elements: [AdViewModel])>()
        var curatedList = PublishSubject<(totalCount: Int, elements: [AdViewModel])>()
        var soldList = PublishSubject<(totalCount: Int, elements: [AdViewModel])>()
    }

    let outputs = Outputs()

    private(set) var isDirty: Bool = false
    var activeListTotalCount = PublishSubject<Int>()
    
    @Injected private var user: WhoppahCore.LegacyUserService
    
    init(activeRepo: MyAdListRepository,
         curatedRepo: MyAdListRepository,
         rejectedRepo: MyAdListRepository,
         draftsRepo: MyAdListRepository,
         soldRepo: OrderRepository,
         productRepo: LegacyProductDetailsRepository) {
        self.activeRepo = activeRepo
        self.curatedRepo = curatedRepo
        self.rejectedRepo = rejectedRepo
        self.draftsRepo = draftsRepo
        self.soldRepo = soldRepo
        self.productRepo = productRepo
        repos = [activeRepo, curatedRepo, rejectedRepo, draftsRepo]
        
        let activeItems = self.activeRepo.items.compactMap { (result) -> (totalCount: Int, elements: [AdViewModel])? in
            if case let .success((total, ads)) = result { return (totalCount: total, elements: ads) }
            return nil
        }
        
        activeItems.bind(to: outputs.activeList).disposed(by: bag)
        
        let curatedItems = self.curatedRepo.items.compactMap { (result) -> (totalCount: Int, elements: [AdViewModel])? in
            if case let .success((total, ads)) = result { return (totalCount: total, elements: ads) }
            return nil
        }
        curatedItems.bind(to: outputs.curatedList).disposed(by: bag)

        let rejectedItems = self.rejectedRepo.items.compactMap { (result) -> (totalCount: Int, elements: [AdViewModel])? in
            if case let .success((total, ads)) = result { return (totalCount: total, elements: ads) }
            return nil
        }
        rejectedItems.bind(to: outputs.rejectedList).disposed(by: bag)

        let draftItems = self.draftsRepo.items.compactMap { (result) -> (totalCount: Int, elements: [AdViewModel])? in
            if case let .success(ads) = result { return ads }
            return nil
        }
        draftItems.bind(to: outputs.draftList).disposed(by: bag)

        let soldItems = self.soldRepo.items.compactMap { [weak self] (result) -> (totalCount: Int, elements: [AdViewModel])? in
            guard let self = self else { return nil }
            switch result {
            case let .success(orders):
                let soldItems = orders.map { (item) -> AdViewModel in
                    AdViewModel(product: item.product)
                }
                return (totalCount: soldItems.count, elements: soldItems)
            case .failure:
                break
            }
            return nil
        }
        soldItems.bind(to: outputs.soldList).disposed(by: bag)

        NotificationCenter.default.addObserver(self, selector: #selector(onAdListUpdated(_:)), name: InAppNotifier.NotificationName.adCreated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdListUpdated(_:)), name: InAppNotifier.NotificationName.adUpdated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdDeleted(_:)), name: InAppNotifier.NotificationName.adDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdReposted(_:)), name: InAppNotifier.NotificationName.adReposted.name, object: nil)
    }

    func fetchMyAds(userId _: UUID) {
        isDirty = false
        activeRepo.load()
        curatedRepo.load()
        rejectedRepo.load()
        draftsRepo.load()

        guard let id = user.current?.merchantId else { return }
        soldRepo.load(merchantId: id)
    }

    func getAdListViewModel(forType: AdListType, userID: UUID) -> MyAdListOverviewViewModel {
        switch forType {
        case .active:
            return MyAdListOverviewViewModel(forType, userID: userID, repo: activeRepo, productDetailsRepo: productRepo)
        case .curated:
            return MyAdListOverviewViewModel(forType, userID: userID, repo: curatedRepo, productDetailsRepo: productRepo)
        case .rejected:
            return MyAdListOverviewViewModel(forType, userID: userID, repo: rejectedRepo, productDetailsRepo: productRepo)
        case .draft:
            return MyAdListOverviewViewModel(forType, userID: userID, repo: draftsRepo, productDetailsRepo: productRepo)
        case .sold:
            fatalError("Should not be fetching ad list for 'sold' items")
        }
    }

    func getMyIncomeViewModel() -> MyIncomeViewModel {
        MyIncomeViewModel(repo: soldRepo)
    }
}

extension MyAdsViewModel {
    @objc func onAdDeleted(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo["id"] as? UUID else { return }
        onAdDeleted(id: id)
    }

    func onAdDeleted(id: UUID) {
        for repo in repos {
            repo.onAdDeleted(id: id)
        }
    }

    @objc func onAdReposted(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo["id"] as? UUID else { return }
        onAdReposted(id: id)
    }

    func onAdReposted(id _: UUID) {
        isDirty = true
    }

    @objc func onAdListUpdated(_: Notification) {
        isDirty = true
    }
}
