//
//  AdViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 24/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

let adLikeChange = Notification.Name("com.whoppah.app.like.changed")
let adIdObject = "ad_id"
let adFavoriteId = "favorite_id"

class AdViewModel {
    var product: WhoppahCore.Product
    var productClick = PublishSubject<WhoppahCore.Product>()
    var arClick = PublishSubject<WhoppahCore.Product>()

    @Injected private var eventTracking: EventTrackingService
    @Injected var mediaCache: MediaCacheService
    @Injected private var apollo: ApolloService
    
    private let bag: DisposeBag

    init(product: WhoppahCore.Product) {
        bag = DisposeBag()
        self.product = product

        NotificationCenter.default.addObserver(self, selector: #selector(onAdLikeChanged(_:)), name: adLikeChange, object: nil)

        // Skip the first message (behavior relay)
        isLiked.asDriver().skip(1).distinctUntilChanged().drive(onNext: { [weak self] result in
            self?.eventTracking.trackFavouriteStatusChanged(ad: product, status: result)
        }).disposed(by: bag)
    }

    var id: UUID { product.id }
    var title: String { product.title }
    var price: NSAttributedString {
        guard isActive() else {
            if let auction = product.currentAuction, auction.state == .reserved || auction.state == .completed {
                return makeBoldText(R.string.localizable.auctionStateCompleted())
            }
            return makeBoldText(R.string.localizable.productUnavailable())
        }
        guard let price = product.price else {
            return makeBoldText(R.string.localizable.productUnavailable())
        }
        if let auction = product.currentAuction {
            if let minBid = auction.minBid, auction.allowBid {
                let minBidText = minBid.formattedPrice()
                let text = R.string.localizable.commonBidFromPrice(minBidText)
                let range = NSRange(location: text.count - minBidText.count, length: minBidText.count)
                return makeBoldText(text, range: range)
            }
        }
        return makeBoldText(price.formattedPrice())
    }

    // Whether we show the overlay
    var showInactiveOverlay: Bool { !isActive() }
    var thumbnail: Image? {
        product.image.first
    }

    var video: Video? { product.video.first }
    var supportsAR: Bool { product.supportsAR }
    var badge: ProductBadge? { product.badge }

    private func isActive() -> Bool {
        guard let auctionState = product.currentAuction?.state else { return false }
        return product.state == .accepted && auctionState == .published
    }

    var priceColor: UIColor {
        if isActive() {
            return UIColor.shinyBlue
        } else {
            return UIColor.redInvalid
        }
    }

    lazy var isLiked = BehaviorRelay<Bool>(value: self.product.isFavorite)
    var showLike: Observable<Bool> { Observable.just(true) }

    /// Returns the like status
    @discardableResult
    func toggleLikeStatus() -> ConnectableObservable<Bool> {
        let observable = ToggleLike.toggleProductLikeStatus(apollo: apollo, productId: product.id, favoriteId: product.favoriteId).publish()
        observable.subscribe(onNext: { [weak self] res in
            self?.isLiked.accept(res)
        }).disposed(by: bag)
        return observable
    }

    @objc private func onAdLikeChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let id = userInfo[adIdObject] as? UUID, id == product.id else {
            return
        }
        let favoriteId = userInfo[adFavoriteId]
        let status = (favoriteId as? UUID) != nil
        product.favoriteId = favoriteId as? UUID
        isLiked.accept(status)
    }

    func onClicked() {
        productClick.onNext(product)
    }

    func onARClicked() {
        arClick.onNext(product)
    }

    private func makeBoldText(_ text: String, range: NSRange? = nil) -> NSAttributedString {
        let boldFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        let textRange = range ?? NSRange(location: 0, length: text.count)
        let attrs = [
            NSAttributedString.Key.font: UIFont.smallText
        ]
        let attrString = NSMutableAttributedString(string: text, attributes: attrs)
        attrString.addAttribute(.font, value: boldFont, range: textRange)
        return attrString
    }
}
