//
//  MyAdListOverviewViewModel.swift
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
import WhoppahDataStore

enum AdListType {
    case active
    case sold
    case curated
    case rejected
    case draft
}

struct AdOverviewCellData {
    let ID: UUID
    let auctionId: UUID?
    let title: String
    let price: String
    let imageUrl: URL?
    let canDelete: Bool
    let canRepost: Bool
    let canEdit: Bool
}

class MyAdListOverviewViewModel {
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var ads: ADsService
    
    private let repo: MyAdListRepository
    private let productDetailsRepo: LegacyProductDetailsRepository
    private let bag = DisposeBag()
    private var cells = [AdOverviewCellData]()
    private let userID: UUID

    struct Outputs {
        let ads = BehaviorSubject<[AdOverviewCellData]>(value: [])
        let title = BehaviorSubject<String>(value: "")
        let subtitle = BehaviorSubject<String>(value: "")
        let error = PublishSubject<Error>()
    }

    let outputs = Outputs()

    init(_ type: AdListType,
         userID: UUID,
         repo: MyAdListRepository,
         productDetailsRepo: LegacyProductDetailsRepository) {
        self.repo = repo
        self.userID = userID
        self.productDetailsRepo = productDetailsRepo

        switch type {
        case .active:
            outputs.title.onNext(R.string.localizable.myProfileMyAdsActiveScreenTitle())
            outputs.subtitle.onNext(R.string.localizable.myProfileMyAdsActiveScreenSubtitle())
        case .curated:
            outputs.title.onNext(R.string.localizable.myProfileMyAdsCurationScreenTitle())
            outputs.subtitle.onNext(R.string.localizable.myProfileMyAdsCurationScreenSubtitle())
        case .rejected:
            outputs.title.onNext(R.string.localizable.myProfileMyAdsRejectedScreenTitle())
            outputs.subtitle.onNext(R.string.localizable.myProfileMyAdsRejectedScreenSubtitle())
        case .draft:
            outputs.title.onNext(R.string.localizable.myProfileMyAdsDraftScreenTitle())
            outputs.subtitle.onNext(R.string.localizable.myProfileMyAdsDraftScreenSubtitle())
        case .sold:
            outputs.title.onNext(R.string.localizable.my_ads_sold_screen_title())
        }

        repo.items.map { [weak self] (result) -> [AdOverviewCellData] in
            switch result {
            case let .success((_, models)):
                guard let self = self else { return [] }
                let newCells = models.map { (model) -> AdOverviewCellData in
                    let title = model.title.uppercased()
                    let price = model.product.price?.formattedPrice() ?? ""
                    let thumbUrl = model.thumbnail?.asURL()
                    return AdOverviewCellData(ID: model.product.id,
                                              auctionId: model.product.currentAuction?.id,
                                              title: title,
                                              price: price,
                                              imageUrl: thumbUrl,
                                              canDelete: self.canDeleteItem(model),
                                              canRepost: self.canRepostItem(model),
                                              canEdit: self.canEditItem(model))
                }
                if self.repo.pager.isFirstPage() {
                    self.cells.removeAll()
                }
                for newCell in newCells {
                    // Merge cells
                    if let index = self.cells.firstIndex(where: { $0.ID == newCell.ID }) {
                        self.cells[index] = newCell
                    } else {
                        self.cells.append(newCell)
                    }
                }
                return self.cells
            case let .failure(error):
                self?.outputs.error.onNext(error)
                return []
            }
        }.bind(to: outputs.ads).disposed(by: bag)

        NotificationCenter.default.addObserver(self, selector: #selector(onAdDeleted(_:)), name: InAppNotifier.NotificationName.adDeleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAdReposted(_:)), name: InAppNotifier.NotificationName.adReposted.name, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func reloadAds() {
        repo.load()
    }

    func loadMoreAds() -> Bool {
        repo.loadMore()
    }

    var numItems: Int {
        repo.numitems()
    }

    private func canDeleteItem(_ ad: AdViewModel) -> Bool {
        canDeleteProduct(ad.product.state, ad.product.currentAuction?.state)
    }

    private func canRepostItem(_ ad: AdViewModel) -> Bool {
        canRepostProduct(ad.product.state, ad.product.currentAuction?.state)
    }

    private func canEditItem(_ ad: AdViewModel) -> Bool {
        canEditProduct(ad.product.state, ad.product.currentAuction?.state)
    }

    func showDeleteDialog(_ id: UUID) -> Bool {
        guard let ad = repo.getAd(id: id) else { return false }
        return ads.canWithdrawAd(state: ad.product.state)
    }

    func deleteAd(_ id: UUID, reason: GraphQL.ProductWithdrawReason? = nil) -> Observable<Void> {
        guard let ad = repo.getAd(id: id) else { return Observable.just(()) }
        return ads.deleteAd(id: id, state: ad.product.state, reason: reason).map { [weak self] in
            self?.onAdDeleted(id: id)
        }
    }

    func repostAd(_ auctionId: UUID, id: UUID) -> Observable<Void> {
        ads.repostAd(id: auctionId).map { [weak self] _ in
            self?.onAdReposted(id: id)
            return ()
        }
    }

    typealias AdFetchCallback = ((Result<AdTemplate, Error>) -> Void)
    func getAdDetails(_ id: UUID, completion: @escaping AdFetchCallback) {
        productDetailsRepo.fetchProduct(id: id).subscribe(onNext: { [weak self] data in
            guard let self = self, let user = self.user.current else { return }
            let template = getTemplate(data, merchant: user.mainMerchant)
            completion(.success(template))
        }, onError: { error in
            completion(.failure(error))
        }).disposed(by: bag)
    }
}

extension MyAdListOverviewViewModel {
    @objc func onAdDeleted(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo["id"] as? UUID else { return }
        onAdDeleted(id: id)
    }

    private func onAdDeleted(id: UUID) {
        repo.onAdDeleted(id: id)
        cells.removeAll(where: { $0.ID == id })
        outputs.ads.onNext(cells)
    }

    @objc func onAdReposted(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo["id"] as? UUID else { return }
        onAdReposted(id: id)
    }

    private func onAdReposted(id: UUID) {
        repo.onAdReposted(id: id)
        cells.removeAll(where: { $0.ID == id })
        outputs.ads.onNext(cells)
    }
}
