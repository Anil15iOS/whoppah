//
//  AdViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit // Only for UIColor
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

enum ImageButtonType {
    case none
    case expired
    case declined
}

struct AdStatisticsUIData {
    let ID: UUID
    let title: String?
    let images: [AdImageData]
    let videos: [AdVideoData]
    let viewsCount: Int
    let likesCount: Int
    let shareCount: Int?
    let body: NSAttributedString
    let status: String
    let statusColor: UIColor
    let imageButtonType: ImageButtonType
    let editButtonEnabled: Bool
    let deleteButtonEnabled: Bool
    let viewButtonEnabled: Bool
}

class MyAdStatisticsViewModel {
    private var adStats: AdStatisticsUIData?
    private var product: ProductDetails?
    
    @Injected private var adService: ADsService
    @Injected private var eventService: EventTrackingService
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var adCreator: ADCreator
    
    private let repo: MyAdStatisticsRepository
    private let bag = DisposeBag()

    struct Outputs {
        var uiData: Observable<AdStatisticsUIData?> {
            _uiData.asObservable()
        }

        fileprivate var _uiData = BehaviorSubject<AdStatisticsUIData?>(value: nil)

        var error: Observable<Error> { _error.asObservable() }
        fileprivate var _error = PublishSubject<Error>()
    }
    
    @Injected private var inAppNotifier: InAppNotifier

    let outputs = Outputs()

    var adID: UUID

    init(withID id: UUID,
         repo: MyAdStatisticsRepository) {
        adID = id
        self.repo = repo

        repo.productDetails.subscribe(onNext: { [weak self] product in
            guard let product = product, let self = self else { return }
            self.product = product
            self.outputs._uiData.onNext(self.getAdUIData(product as ProductDetails))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.outputs._error.onNext(error)
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adMediaChanged, object: nil).subscribe(onNext: { [weak self] _ in
            self?.onAdMediaUpdated()
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adUpdated, object: nil).subscribe(onNext: { [weak self] notification in
            self?.onAdUpdated(_:)(notification)
        }).disposed(by: bag)
    }

    @objc private func onAdUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let ad = userInfo["ad"] as? ProductDetails else { return }
        DispatchQueue.main.async {
            self.outputs._uiData.onNext(self.getAdUIData(ad))
        }
    }

    @objc private func onAdMediaUpdated() {
        guard let product = product else { return }
        outputs._uiData.onNext(getAdUIData(product as ProductDetails))
    }

    func getAdTemplate() -> AdTemplate {
        getTemplate(product!, merchant: user.current!.mainMerchant)
    }

    private func getAdUIData(_ ad: ProductDetails) -> AdStatisticsUIData {
        var statusColor = UIColor.black
        var buttonType = ImageButtonType.none
        let allowEdit = canEditProduct(ad.state, ad.currentAuction?.state)
        let allowDelete = canDeleteProduct(ad.state, ad.currentAuction?.state)
        let productStateTitle = ad.state.title
        var body = NSMutableAttributedString(string: productStateTitle)
        var status = productStateTitle

        var canView = true
        switch ad.state {
        case .accepted:
            var showInactive = false
            if let auction = ad.currentAuction {
                let auctionState = auction.state.title
                body = NSMutableAttributedString(string: auctionState)
                status = auctionState

                switch auction.state {
                case .published:
                    if let text = auction.endDate?.date.textUntilAdExpiry() {
                        body = NSMutableAttributedString(string: text)
                    } else {
                        body = NSMutableAttributedString(string: R.string.localizable.my_ad_no_expiry())
                    }
                case .expired:
                    buttonType = .expired
                case .reserved:
                    statusColor = .redInvalid
                case .draft, .completed, .canceled: break
                case .banned:
                    showInactive = true
                case .__unknown:
                    showInactive = true
                }
            } else {
                showInactive = true
            }

            if showInactive {
                body = NSMutableAttributedString(string: R.string.localizable.productUnavailable())
                status = R.string.localizable.productUnavailable()
                statusColor = .black
                buttonType = .expired
            }

        case .rejected:
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.redInvalid]
            body = NSMutableAttributedString(string: productStateTitle, attributes: attributes)

            buttonType = .declined
            statusColor = .redInvalid
        case .banned:
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.redInvalid]
            body = NSMutableAttributedString(string: productStateTitle, attributes: attributes)

            buttonType = .none
            statusColor = .redInvalid
        case .curation, .draft, .updated, .archive:
            break
        case .canceled:
            canView = false
        case .__unknown:
            statusColor = .redInvalid
        }

        var images = ad.getImages()
        images.append(contentsOf: ad.getDraftImages(id: ad.id,
                                                    mediaManager: adCreator.mediaManager))
        var videos = ad.getVideos()
        videos.append(contentsOf: ad.getDraftVideos(id: ad.id,
                                                    mediaManager: adCreator.mediaManager))
        return AdStatisticsUIData(
            ID: adID,
            title: ad.title,
            images: images,
            videos: videos,
            viewsCount: ad.viewCount,
            likesCount: ad.favoriteCount,
            shareCount: 0,
            body: body,
            status: status,
            statusColor: statusColor,
            imageButtonType: buttonType,
            editButtonEnabled: allowEdit,
            deleteButtonEnabled: allowDelete,
            viewButtonEnabled: canView
        )
    }

    func loadAd() {
        repo.watchProduct(id: adID)
    }

    func showDeleteDialog() -> Bool {
        guard let product = product else { return true }
        return adService.canWithdrawAd(state: product.state)
    }

    func deleteAd(_ reason: GraphQL.ProductWithdrawReason? = nil) -> Observable<Void> {
        guard let product = product else { return Observable.just(()) }
        return adService.deleteAd(id: adID, state: product.state, reason: reason).map { [weak self] in
            guard let self = self else { return }
            self.inAppNotifier.notify(.adDeleted, userInfo: ["id": self.adID])
            return ()
        }
    }

    func repostAd() -> Observable<Void> {
        guard let auctionId = product?.currentAuction?.id else { return Observable.just(()) }
        return adService.repostAd(id: auctionId).map { [weak self] _ in
            guard let self = self else { return }
            self.inAppNotifier.notify(.adReposted, userInfo: ["id": self.adID])
            return ()
        }
    }
}

extension MyAdStatisticsViewModel {
    func trackVideoViewed() {
        guard let ad = product else { return }
        eventService.trackVideoViewed(ad: ad, isFullScreen: false, page: .adStats)
    }
}
