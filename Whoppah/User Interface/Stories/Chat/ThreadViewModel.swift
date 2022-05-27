//
//  ThreadViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 02/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

struct ThreadUIData {
    let imageUrl: URL?
    let title: String
    let userTitle: String
    let isBusiness: Bool
    let status: String
    let statusVisible: Bool
    let showReportOptions: Bool
    let delivery: AdDelivery?
    let pickUp: AdPickup?
}

struct DeliveryUIData {
    let delivery: AdDelivery
    let pickUp: AdPickup
}

enum ThreadError: Error {
    case missingThread
    case missingUser
}

class ThreadViewModel {
    private let threadID: UUID?
    private var thread: GraphQL.GetThreadQuery.Data.Thread? {
        didSet {
            if let thread = thread {
                if let product = thread.item.asProduct {
                    threadType = .product(data: product)
                } else if let merchant = thread.item.asMerchant {
                    threadType = .merchant(data: merchant)
                }
            } else {
                threadType = nil
            }
        }
    }

    let coordinator: ThreadCoordinator
    private let repo: ThreadRepository
    private let bag = DisposeBag()

    private enum ThreadType {
        case product(data: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct)
        case merchant(data: GraphQL.GetThreadQuery.Data.Thread.Item.AsMerchant)
    }

    private var threadType: ThreadType?

    typealias ThreadUpdated = (Result<ThreadUIData, Error>) -> Void
    var onThreadUpdated: ThreadUpdated?
    var deliveryData: DeliveryUIData?
    
    @Injected private var crashReporter: CrashReporter
    @Injected private var pushService: PushNotificationsService
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected private var auctionService: AuctionService
    @Injected private var eventTrackingService: EventTrackingService

    struct Outputs {
        var showBidUI: Observable<Bool> { _showBidUI.asObservable() }
        fileprivate let _showBidUI = BehaviorRelay<Bool>(value: false)
    }
    
    let outputs = Outputs()
    
    init(threadID ID: UUID,
         repo: ThreadRepository,
         coordinator: ThreadCoordinator) {
        threadID = ID
        self.repo = repo
        self.coordinator = coordinator

        repo.thread.compactMap { $0 }.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.thread = data
            self.onThreadUpdated?(self.getThreadUIData())
        }, onError: { [weak self] error in
            self?.crashReporter.log(error: error,
                                   withInfo: ["screen": "thread", "id": "\(ID)"])
            self?.onThreadUpdated?(.failure(error))
        }).disposed(by: bag)
    }

    init(thread: GraphQL.GetThreadQuery.Data.Thread,
         repo: ThreadRepository,
         coordinator: ThreadCoordinator) {
        self.thread = thread
        threadID = nil
        self.repo = repo
        self.coordinator = coordinator
    }
    
    func assignThreadID() {
        if let thread = thread {
            pushService.openedThreadID = thread.id
        } else if let threadID = threadID {
            pushService.openedThreadID = threadID
        }
    }

    func fetchThread() {
        if thread != nil {
            onThreadUpdated?(getThreadUIData())
        } else if let threadID = threadID {
            // Why does this delay exist??
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                self.repo.fetchThread(id: threadID)
            }
        }
    }

    func canReportUser() -> Bool {
        if case .product = threadType {
            return true
        }
        return false
    }

    func reportUser() {
        guard let type = threadType else { return }
        switch type {
        case let .product(data):
            coordinator.reportUser(userID: data.merchant.id)
        case let .merchant(data):
            coordinator.reportUser(userID: data.id)
        }
    }

    func canReportProduct() -> Bool {
        if case .product = threadType {
            return true
        }
        return false
    }

    func reportProduct() {
        if case let .product(data) = threadType {
            coordinator.reportProduct(itemID: data.id)
        }
    }

    func openThreadItem() {
        guard let type = threadType else { return }
        switch type {
        case let .product(data):
            coordinator.openAd(adID: data.id)
        case let .merchant(data):
            coordinator.openProfile(id: data.id)
        }
    }
    
    func showMore() {
        coordinator.showMore(reportUser: canReportUser(), reportProduct: canReportProduct())
    }

    func showHelp() {
        coordinator.showHelp()
    }
    
    private func getDeliveryData() -> DeliveryUIData {
        return deliveryData!
    }
    
    private func getThreadUIData() -> Result<ThreadUIData, Error> {
        guard let type = threadType else { return .failure(ThreadError.missingThread) }
        guard let myMerchant = userService.current?.mainMerchant else { return .failure(ThreadError.missingUser) }
        var title: String?
        let userTitle: String
        var status: String?
        var image: URL?
        var isActive = false
        var delivery: AdDelivery?
        var pickup: AdPickup?
        var isBusiness = false
        
        delivery = getDeliveryDetails(thread!.item.asProduct!)
        pickup = getPickUpDetails(thread!.item.asProduct!)
        
        switch type {
        case let .product(data):
            title = data.title
            if let merchant = thread?.subscribers.first(where: { $0.merchant.id != myMerchant.id })?.merchant {
                userTitle = getMerchantDisplayName(type: merchant.type, businessName: merchant.businessName, name: merchant.name, hideBusinessName: false)
                isBusiness = merchant.type == .business
            } else {
                userTitle = data.title
            }

            status = data.auction?.state.title.uppercased()
            isActive = true
            if let urlString = data.thumbnails.first?.url {
                image = URL(string: urlString)
            }
            
            var canBid = false
            
            if let auction = data.auction, auction.allowBid,
                auction.state == .published {
                if let myMember = userService.current {
                    if data.merchant.id != myMember.merchantId {
                        canBid = !self.hasApprovedBidFromMe()
                    }/* else {
                        let otherBid = self.getFirstBuyerBid()
                        canBid = otherBid != nil
                    }*/
                } else {
                    self.outputs._showBidUI.accept(false)
                }
            }
            
            self.outputs._showBidUI.accept(canBid)
        case let .merchant(data):
            title = ""
            userTitle = data.name

            if let urlString = data.avatar?.url {
                image = URL(string: urlString)
            }            
        }

        let showReportOptions = canReportUser() || canReportProduct()
        
        deliveryData = DeliveryUIData(delivery: delivery!, pickUp: pickup!)
        return .success(ThreadUIData(imageUrl: image,
                                     title: title ?? "",
                                     userTitle: userTitle,
                                     isBusiness: isBusiness,
                                     status: status ?? "",
                                     statusVisible: isActive,
                                     showReportOptions: showReportOptions,
                                     delivery: delivery,
                                     pickUp: pickup))
    }
    
    private func getDeliveryDetails(_ ad: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct) -> AdDelivery {
        var deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()
        var method = ""
        var description = ""
        var type = "unknown"

        if ad.deliveryMethod == .pickup {
            return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
        }

        if let shipping = ad.shippingMethod {
            deliveryCost = ad.shippingCost.amount.formattedPrice(showFraction: true, currency: ad.shippingCost.currency)
            type = shipping.slug.capitalizingFirstLetter()
        }

        method = localizedString("product-shipping-\(type)-title") ?? R.string.localizable.ad_details_delivery_title()

        if let localizedDescription = localizedString("product-shipping-\(type)-description") {
            description = String(format: localizedDescription, deliveryCost)
        } else {
            description = R.string.localizable.ad_details_delivery_title()
        }
        return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
    }
    
    private func getPickUpDetails(_ ad: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct) -> AdPickup {
        if ad.deliveryMethod == .delivery && ad.shippingMethod?.slug != "custom"{
            return AdPickup(description: "", price: "")
        }
        let deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()

        return AdPickup(description: localizedString("product-shipping-pickup") ?? "", price: deliveryCost)
    }
    
    private func hasApprovedBidFromMe() -> Bool {
        guard let thread = thread, let auction = thread.item.asProduct?.auction else { return false }
        let merchantId = userService.current?.merchantId

        // Ensure that there has been a bid from a buyer and that the buyer is one of the subscribers of this chat
        // NOTE: Auction bids are across ALL users and threads, that's why they need to be filtered first by subscribers
        let subscribers = thread.subscribers.map { $0.merchant.id }
        return auction.bids.contains(where: { $0.buyer.id == merchantId && subscribers.contains($0.buyer.id) && $0.state.isApproved() })
    }
    
    private func getFirstBuyerBid() -> GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct.Auction.Bid? {
        guard let thread = thread, let auction = thread.item.asProduct?.auction else { return nil }
        let merchantId = userService.current?.merchantId

        // Ensure that there has been a bid from a buyer and that the buyer is one of the subscribers of this chat
        // (so we don't get other chat bids in here)
        // Merchant can only counter bid if there's been a bid from another subscriber
        // AND if the bid is not approved
        let subscribers = thread.subscribers.map { $0.merchant.id }
        // NOTE: Auction bids are across ALL users and threads, that's why they need to be filtered first by subscribers
        let subscriberBids = auction.bids.filter { $0.buyer.id != merchantId && subscribers.contains($0.buyer.id) }
        guard subscriberBids.first(where: { $0.state.isApproved() }) == nil else { return nil }

        return subscriberBids.first(where: { !$0.state.isApproved() })
    }
    
    enum BidError: Error {
        case minPriceNotMet(minPrice: PriceInput)
    }

    func doBid(amount: Double) -> Observable<Result<Void, Error>> {
        let merchantId = userService.current!.mainMerchant.id
        return Observable.create { (observer) -> Disposable in

            guard let thread = self.thread else { observer.onCompleted(); return Disposables.create() }
            guard let product = thread.item.asProduct, let auction = product.auction else { observer.onCompleted(); return Disposables.create() }
            var currency = GraphQL.Currency.eur
            if let minBid = auction.minimumBid, amount < minBid.amount {
                currency = minBid.currency
                let price = PriceInput(currency: minBid.currency, amount: Double(minBid.amount.rounded(.up)))
                observer.onError(BidError.minPriceNotMet(minPrice: price))
                return Disposables.create()
            }

            let price = PriceInput(currency: currency, amount: amount)
            var obs: Observable<Bid>!
            if product.merchant.id == merchantId {
                var buyerId: UUID?
                if let existingBid = self.getFirstBuyerBid() {
                    buyerId = existingBid.buyer.id
                } else {
                    if thread.startedBy.id != merchantId {
                        buyerId = thread.startedBy.id
                    } else {
                        buyerId = thread.subscribers.first(where: { $0.merchant.id != merchantId })?.id
                    }
                }
                guard let buyer = buyerId else {
                    observer.onError(ChatError.noTargetSubscriberFound)
                    return Disposables.create()
                }
                obs = self.auctionService.createCounterBid(productId: product.id, auctionId: auction.id, amount: price, buyerId: buyer)
            } else {
                obs = self.auctionService.createBid(productId: product.id, auctionId: auction.id, amount: price, createThread: true)
            }

            obs.subscribe(onNext: { [weak self] bid in
                guard let self = self else { return }
                UserDefaultsConfig.onBidPlaced(bid.id)
                self.eventTrackingService.trackSendMessage(receiverID: product.merchant.id,
                                               adID: product.id,
                                               conversationID: thread.id,
                                               counterBid: bid.price.amount,
                                               textMessage: false,
                                               isPDPQuestion: false)

                observer.onNext(.success(()))
            }, onError: { [weak self] error in
                let threadID = thread.id
                let threadAdID = product.id
                
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "chat", "type": "bid_create", "thread_id": "\(threadID)", "thread_ad_id": "\(threadAdID)"])

                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
}
