//
//  AdDetailsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 15/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

enum AdDimensions {
    case present(width: String?, height: String?, depth: String?)
    case notPresent
}

struct AdDelivery {
    let method: String
    let description: String
    let type: String
    let price: String
}

struct AdPickup {
    let description: String
    let price: String
}

struct AdBid {
    let hasBid: Bool
    let text: String
    let isUnavailable: Bool
}

enum AdUIStatus {
    case active
    case sold
    case reserved
    case other
}

enum AdBidSource {
    case ar
    case bidTopSection
    case bidButton
}

struct AdDetailUIData {
    let ID: UUID
    let price: Price?
    let title: String
    let isVerified: Bool
    let description: String
    let createdAtText: String
    let username: String
    let joinedText: String
    let status: AdUIStatus
    let viewsText: String
    let showMoreMenu: Bool
    let isBusiness: Bool

    let categoryAdText: String
    let brandText: String // empty when no brand is associated
    let brandDescription: String
    let artistText: String // empty when no artist is associated
    let designerText: String // empty when no designer is associated
    let materialText: String // empty when there are no materials
    let styleText: String // empty when there are no styles
    let delivery: AdDelivery
    let pickUp: AdPickup
    let dimension: AdDimensions
    let showBottomPurchaseSection: Bool
    let showAskQuestion: Bool
    let canBid: Bool
    let canBuy: Bool
    let showGoToChat: Bool
    let showPayNow: Bool
    let buyNowButtonText: String
    let currency: String
    let bidFromText: String
    let bidInfo: AdBid
    let rawAd: ProductDetails
    let hasAR: Bool
    let images: [AdImageData]
    let videos: [AdVideoData]
    let badge: ProductBadge?
    let isMyAd: Bool
}

class AdDetailsViewModel {
    @Injected private var crashReporter: CrashReporter
    
    private let adID: UUID
    private var product: GraphQL.ProductQuery.Data.Product?

    let coordinator: AdDetailsCoordinator
    @Injected private var adService: ADsService
    @Injected private var adCreator: ADCreator
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected private var locationService: LocationService
    @Injected private var merchantService: MerchantService
    @Injected private var chatService: ChatService
    @Injected private var searchService: SearchService
    @Injected private var eventTrackingService: EventTrackingService
    @Injected private var languageTranslationService: LanguageTranslationService
    @Injected var mediaCache: MediaCacheService
    @Injected private var auctionService: AuctionService
    @Injected private var apolloService: ApolloService
    
    private var adLocation: Point?
    private var userLocation: Point?
    private let adRepo: LegacyProductDetailsRepository
    private let bidRepo: BidRepository
    private let currentBidPrice = BehaviorRelay<Money?>(value: nil)
    private var bidSource: BidSource?

    struct Inputs {
        let bidAmount = BehaviorSubject<String?>(value: "")
    }

    struct Outputs {
        let isLiked = BehaviorSubject<Bool>(value: false)
        let isUserTypeMerchant = BehaviorSubject<Bool>(value: false)
        let likeText = BehaviorSubject<String>(value: "")
        let distanceText = BehaviorSubject<String>(value: "")

        var styles = BehaviorSubject<[TextStyleViewModel]>(value: [])
        var colorHex: Observable<[String]> { _colorHex.asObservable() }
        fileprivate let _colorHex = BehaviorRelay<[String]>(value: [])

        var bidButtonEnabled: Observable<Bool> { _bidButtonEnabled.asObservable() }
        fileprivate let _bidButtonEnabled = BehaviorRelay<Bool>(value: false)
    }

    let inputs = Inputs()
    let outputs = Outputs()

    private let bag = DisposeBag()

    var adData = BehaviorSubject<AdDetailUIData?>(value: nil)

    init(adID: UUID,
         coordinator: AdDetailsCoordinator,
         adRepo: LegacyProductDetailsRepository,
         bidRepo: BidRepository) {
        self.adID = adID
        self.coordinator = coordinator
        self.adRepo = adRepo
        self.bidRepo = bidRepo

        inputs.bidAmount.map { $0?.getPrice() }
            .bind(to: currentBidPrice)
            .disposed(by: bag)

        currentBidPrice
            .map { [weak self] price -> Bool in
                guard let price = price else { return false }
                guard let self = self, let min = self.product?.auction?.minBid else { return false }
                return price >= min.amount
            }
            .bind(to: outputs._bidButtonEnabled)
            .disposed(by: bag)

        loadAd()
    }
    
    func translate(strings: [String], lang: GraphQL.Lang, completion: @escaping (LegacyTranslationResponse?) -> Void) {
        languageTranslationService.translate(strings: strings, language: lang)
            .subscribe(onNext: { translation in
                completion(translation)
            }).disposed(by: bag)
    }

    func loadAd() {
        adRepo.productDetails
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] product in
                guard let self = self, let product = product else { return }
                // We may get several calls through here
                // Only send the first as a view
                if self.product == nil {
                    self.sendProductViewEvent(product)
                    self.loadRelatedItems(product)
                }
                self.product = product
                self.adData.onNext(self.getAdDetailsUIData())
                self.outputs.styles.onNext(product.styles.map { TextStyleViewModel(style: $0) })
                self.outputs._colorHex.accept(product.colors.map { $0.hex })
            }, onError: { [weak self] error in
                self?.adData.onError(error)
            }).disposed(by: bag)
        adRepo.watchProduct(id: adID)
    }

    func goToChat() {
        navigateToChat()
    }

    func payNow() {
        guard let bid = getApprovedBid() else { return }
        navigateToCheckout(bidId: bid.id, orderId: bid.order?.id)
    }

    enum ProductPaymentState {
        case none
        case paymentRequired
        case paymentMade
    }

    private func getPaymentState() -> ProductPaymentState {
        guard let bid = getApprovedBid() else { return .none }
        // Check the order state (if present)
        if bid.order == nil || bid.order?.state == .new {
            return .paymentRequired
        }
        return .paymentMade
    }

    private func getApprovedBid() -> GraphQL.ProductQuery.Data.Product.Auction.Bid? {
        guard let product = product else { return nil }
        let currentMerchant = userService.current?.mainMerchant.id
        return product.auction?.bids.filter { $0.state.isApproved() && $0.buyer.id == currentMerchant }.first
    }

    private func isOwnAd(ad: GraphQL.ProductQuery.Data.Product) -> Bool {
        ad.user.id == userService.current?.merchantId
    }

    private func getDimension(_ ad: GraphQL.ProductQuery.Data.Product) -> AdDimensions {
        var dimension: AdDimensions = .notPresent
        let width = ad.width != nil ? R.string.localizable.ad_details_attr_measurement_centimetres(Double(ad.width!)) : nil
        let height = ad.height != nil ? R.string.localizable.ad_details_attr_measurement_centimetres(Double(ad.height!)) : nil
        let depth = ad.depth != nil ? R.string.localizable.ad_details_attr_measurement_centimetres(Double(ad.depth!)) : nil
        if width == nil || ad.width! <= 0,
            height == nil || ad.height! <= 0,
            depth == nil || ad.depth! <= 0 {
            dimension = .notPresent
        } else {
            dimension = .present(width: width, height: height, depth: depth)
        }
        return dimension
    }

    private func sendProductViewEvent(_ ad: GraphQL.ProductQuery.Data.Product) {
        // Don't send product view events for own ads
        guard !isOwnAd(ad: ad) else { return }
        adService.viewAd(id: ad.id).subscribe(onNext: nil, onError: { [weak self] error in
            self?.crashReporter.log(error: error)
        }).disposed(by: bag)
    }

    private func loadRelatedItems(_ ad: GraphQL.ProductQuery.Data.Product) {
        guard !isOwnAd(ad: ad) else { return }
        adRepo.fetchRelatedItems(product: adID.description).subscribe(onNext: { [weak self] relatedProducts in
            self?.more.moreAds.onNext(relatedProducts.shuffled.prefix(3).compactMap {
                AdViewModel(product: $0 as WhoppahCore.Product)
            })
        }).disposed(by: bag)
    }

    private func getBidDetails(_ ad: GraphQL.ProductQuery.Data.Product) -> AdBid {
        let inactiveText = R.string.localizable.productUnavailable().capitalized
        let isOwn = isOwnAd(ad: ad)

        guard let auction = ad.currentAuction else {
            return AdBid(hasBid: false, text: inactiveText, isUnavailable: true)
        }

        guard !isOwn else {
            let text = auction.state.title.uppercased()
            return AdBid(hasBid: false, text: text, isUnavailable: false)
        }

        guard ad.state == .accepted else {
            return AdBid(hasBid: false, text: inactiveText, isUnavailable: true)
        }

        switch auction.state {
        case .published:
            let paymentState = getPaymentState()
            switch paymentState {
            case .paymentRequired:
                return AdBid(hasBid: false, text: R.string.localizable.ad_details_pay_button(), isUnavailable: false)
            case .paymentMade:
                return AdBid(hasBid: false, text: R.string.localizable.ad_details_chat_button(), isUnavailable: false)
            case .none: break
            }

            guard auction.allowBid, let minBId = auction.minBid else {
                guard auction.allowBuyNow, let price = auction.buyNowValue else {
                    return AdBid(hasBid: false, text: inactiveText, isUnavailable: true)
                }

                let text = R.string.localizable.adDetailsBuyNowPrice(price.formattedPrice())
                return AdBid(hasBid: false, text: text, isUnavailable: false)
            }

            guard let highestBid = auction.currentHighestBid, auction.bidCount > 0 else {
                let text = R.string.localizable.commonBidFromPrice(minBId.formattedPrice())
                return AdBid(hasBid: true, text: text, isUnavailable: false)
            }

            let maxTitle = R.string.localizable.ad_details_max_bid(highestBid.price.formattedPrice())
            return AdBid(hasBid: true, text: maxTitle, isUnavailable: false)
        case .reserved, .completed:
            let text = R.string.localizable.auctionStateCompleted()
            return AdBid(hasBid: false, text: text, isUnavailable: true)
        default: break
        }
        return AdBid(hasBid: false, text: inactiveText, isUnavailable: true)
    }

    private func getDeliveryDetails(_ ad: GraphQL.ProductQuery.Data.Product) -> AdDelivery {
        var deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()
        var method = ""
        var description = ""
        var type = "unknown"
        
        if ad.deliveryMethod == .pickup {
            return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
        }

        if let shipping = ad.shipping {
            deliveryCost = ad.shippingPrice?.formattedPrice(showFraction: true) ?? ""
            type = shipping.slug
        }
        
        method = localizedString("product-shipping-\(type)-title") ?? R.string.localizable.ad_details_delivery_title()
        if let localizedDescription = localizedString("product-shipping-\(type)-description") {
            description = String(format: localizedDescription, deliveryCost)
        } else {
            description = R.string.localizable.ad_details_delivery_title()
        }
        return AdDelivery(method: method, description: description, type: type, price: deliveryCost)
    }
    
    private func getPickUpDetails(_ ad: GraphQL.ProductQuery.Data.Product) -> AdPickup {
        if ad.deliveryMethod == .delivery && ad.shipping?.slug != "custom"{
            return AdPickup(description: "", price: "")
        }
        let deliveryCost = R.string.localizable.ad_details_delivery_pickup_price()
        var description = ""
        
        let countryCode = ad.location?.country ?? ""
        var countryName = ""
        let city = ad.location?.city.trimmingCharacters(in: .whitespaces) ?? ""
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            countryName = name
        } else {
            countryName = countryCode
        }
        
        let location = "\(city), \(countryName)"
        if let localizedDescription = localizedString("product-shipping-pickup-description") {
            description = String(format: localizedDescription, location)
        } else {
            description = R.string.localizable.ad_details_delivery_title()
        }
        return AdPickup(description: description, price: deliveryCost)
    }
    
    private func getAdDetailsUIData() -> AdDetailUIData {
        let ad = product!

        let dimension = getDimension(ad)
        let delivery = getDeliveryDetails(ad)
        let bidDetails = getBidDetails(ad)
        let pickup = getPickUpDetails(ad)

        fetchDistanceText()

        let buyNowText = R.string.localizable.ad_details_btn_buy_now(ad.currentAuction?.buyNowValue?.formattedPrice() ?? "")
        let materialText = ad.materials.compactMap { localizedString(materialTitleKey($0.slug)) }.joined(separator: ", ")
        let brandText = ad.brands.map { $0.title }.joined(separator: ", ")
        let styleText = ad.styles.compactMap { localizedString(styleTitleKey($0.slug)) }.joined(separator: ", ")
        let brandDescription = ad.brands.map { ($0.description ?? "") }.joined(separator: "\n\n")
        let artistText = ad.artists.map { $0.title }.joined(separator: ", ")
        let designerText = ad.designers.map { $0.title }.joined(separator: ", ")
        
        let hasAR = ad.supportsAR
        var bidButton = ad.currentAuction?.allowBid == true
        var buyButton = ad.currentAuction?.allowBuyNow == true
        var goToChatButton = false
        var payButton = false
        var adUIState = AdUIStatus.active

        switch ad.currentAuction?.state ?? .draft {
        case .published:
            adUIState = .active
        case .reserved:
            adUIState = .reserved
            buyButton = false
            bidButton = false
        case .completed:
            adUIState = .sold
            buyButton = false
            bidButton = false
        default:
            adUIState = .other
            buyButton = false
            bidButton = false
        }

        let paymentState = getPaymentState()
        switch paymentState {
        case .none: break
        case .paymentRequired:
            payButton = true
            goToChatButton = false
            buyButton = false
            bidButton = false
        case .paymentMade:
            payButton = false
            goToChatButton = true
            buyButton = false
            bidButton = false
        }

        let currency = ad.auction?.buyNowValue?.currency ?? .eur

        let isMyAd = isOwnAd(ad: ad)
        let showBottomSection = (buyButton || bidButton || payButton || goToChatButton) && !isMyAd

        let username = getMerchantDisplayName(type: ad.merchant.type,
                                              businessName: ad.merchant.businessName,
                                              name: ad.merchant.name)
        let isBusiness = ad.merchant.type == .business

        outputs.isLiked.onNext(ad.isFavorite)
        outputs.likeText.onNext("\(ad.favoriteCount)")
        outputs.isUserTypeMerchant.onNext(ad.merchant.type == .business)
        
        var images = ad.getImages()
        images.append(contentsOf: ad.getDraftImages(id: ad.id,
                                                    mediaManager: adCreator.mediaManager))
        var videos = ad.getVideos()
        videos.append(contentsOf: ad.getDraftVideos(id: ad.id,
                                                    mediaManager: adCreator.mediaManager))
        
        var minBidText = ""
        if let minBid = ad.auction?.minBid {
            minBidText = R.string.localizable.commonBidFromPrice(minBid.formattedPrice())
        }
        
        return AdDetailUIData(ID: ad.id,
                              price: ad.price,
                              title: ad.title,
                              isVerified: ad.user.isVerified,
                              description: ad.description ?? "---",
                              createdAtText: ad.auction?.startDate?.date.activeDaysText() ?? "",
                              username: username,
                              joinedText: ad.merchant.created.date.activeJoinPeriodText() ?? "",
                              status: adUIState,
                              viewsText: "\(ad.viewCount)",
                              showMoreMenu: !isMyAd,
                              isBusiness: isBusiness,
                              categoryAdText: "",
                              brandText: brandText,
                              brandDescription: brandDescription,
                              artistText: artistText,
                              designerText: designerText,
                              materialText: materialText,
                              styleText: styleText,
                              delivery: delivery,
                              pickUp: pickup,
                              dimension: dimension,
                              showBottomPurchaseSection: showBottomSection,
                              showAskQuestion: !isMyAd,
                              canBid: bidButton && !isMyAd,
                              canBuy: buyButton && !isMyAd,
                              showGoToChat: goToChatButton,
                              showPayNow: payButton,
                              buyNowButtonText: buyNowText,
                              currency: currency.text,
                              bidFromText: minBidText,
                              bidInfo: bidDetails,
                              rawAd: ad,
                              hasAR: hasAR,
                              images: images,
                              videos: videos,
                              badge: ad.badge,
                              isMyAd: isMyAd)
    }

    private func computeDistanceText(adCoordinate: Point, userCoordinate: Point, adCountry: String?) {
        let coordinate0 = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let coordinate1 = CLLocation(latitude: adCoordinate.latitude, longitude: adCoordinate.longitude)
        let distance = coordinate0.distance(from: coordinate1)
        var distanceText: String
        if let adCountry = adCountry, let country = Country(rawValue: adCountry)?.title, let emoji = String.emojiFlag(for: adCountry) {
            distanceText = R.string.localizable.ad_details_distance_with_country_to((Int)(distance / 1000), "\(country)") + "  \(emoji)"
        } else {
            distanceText = R.string.localizable.ad_details_distance_to((Int)(distance / 1000))
        }
        outputs.distanceText.onNext(distanceText)
    }

    private func fetchDistanceText() {
        guard let point = product?.location?.point else { return }
        adLocation = point
        
        if let location = product?.location {
            let city = location.city
            let country = Country(rawValue: location.country)?.title ?? ""
            let flagEMoji = String.emojiFlag(for: location.country) ?? ""
            let distanceText = "\(city), \(country) \(flagEMoji)"
            outputs.distanceText.onNext(distanceText)
        }
    }

    // MARK: Actions

    @discardableResult
    func toggleLikeAd() -> ConnectableObservable<Bool>? {
        guard let product = product else { return nil }
        let observable = ToggleLike.toggleProductLikeStatus(apollo: apolloService, productId: product.id, favoriteId: product.favorite?.id).publish()
        observable.subscribe(onNext: { [weak self] result in
            self?.eventTrackingService.trackFavouriteStatusChanged(ad: product, status: result)
        }, onError: { [weak self] error in
            self?.coordinator.showError(error)
        }).disposed(by: bag)
        return observable
    }

    func placeBid(completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let product = product, let auctionId = product.auction?.id, let bidAmount = currentBidPrice.value else { return }
        guard let minBid = product.auction?.minBid else { return }
        didStartBid(bid: bidAmount)

        auctionService.createBid(productId: product.id, auctionId: auctionId, amount: PriceInput(currency: minBid.currency, amount: bidAmount), createThread: true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.bidSource = nil
                self.navigateToChat(completion)
            }, onError: { [weak self] error in
                DispatchQueue.main.async { [weak self] in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "pdp", "type": "buy_now", "id": "\(product.id)"])
                    completion(.failure(error))
                }
            }).disposed(by: bag)
    }

    func buyNowAction(completion: @escaping ((Result<Void, Error>) -> Void)) {
        let state = getPaymentState()
        switch state {
        case .paymentMade:
            return goToChat()
        case .paymentRequired:
            return payNow()
        case .none: break
        }

        guard let product = product, let auctionId = product.auction?.id, let price = product.auction?.buyNowPrice else { return }

        auctionService.createBid(productId: product.id, auctionId: auctionId, amount: PriceInput(currency: price.currency, amount: price.amount), createThread: false)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] bid in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    completion(.success(()))
                }
                self.navigateToCheckout(bidId: bid.id, orderId: nil, withdrawOnReturn: true)
            }, onError: { [weak self] error in
                DispatchQueue.main.async { [weak self] in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "pdp", "type": "buy_now", "id": "\(product.id)"])
                    completion(.failure(error))
                }
            }).disposed(by: bag)
    }

    func openSafeShoppingInfo() {
        coordinator.showAssurance()
        trackSafeShoppingEvent()
    }

    func sendChatMessage(text: String, completion: ((UUID) -> Void)? = nil) {
        guard let product = product else { return }
        chatService.sendProductMessage(id: product.id, body: text)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] id in
                self?.eventTrackingService.trackSendMessage(receiverID: product.user.id,
                                                              adID: product.id,
                                                              conversationID: id,
                                                              counterBid: nil,
                                                              textMessage: true,
                                                              isPDPQuestion: true)
                self?.coordinator.openChatThread(threadID: id)
                completion?(id)
            }, onError: { [weak self] error in
                self?.coordinator.showError(error)
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "pdp", "type": "chat_create", "id": "\(product.id)"])
            }).disposed(by: bag)
    }

    // MARK: Navigation

    func share() {
        guard let url = product?.shareURL else { return }
        let shareText = R.string.localizable.ad_details_default_share_text()
        coordinator.openShareSheet(text: shareText, url: url) { activity in
            self.trackShareCompleted(activity: activity)
        }
        trackShareClicked()
    }

    func onAvatarTapped() {
        if let user = product?.user {
            coordinator.showPublicProfile(id: user.id)
        }
    }

    func showUserReport() {
        guard let product = product else { return }
        coordinator.showUserReport(id: product.user.id)
    }

    func showProductReport() {
        guard let product = product else { return }
        coordinator.showProductReport(id: product.id)
    }

    private func navigateToCheckout(bidId: UUID, orderId: UUID?, withdrawOnReturn: Bool = false) {
        guard let id = product?.id else { return }

        coordinator.showCheckout(id: id, bidId: bidId, orderId: orderId) {
            guard withdrawOnReturn else { return }

            self.bidRepo.get(bidId).subscribe(onNext: { [weak self] bid in
                guard let self = self else { return }
                if bid.order == nil {
                    // Withdrawing the bid allows the PDP to go back to the bid/buy now state
                    self.auctionService.withdrawBid(id: bidId).subscribe(onError: { [weak self] error in
                        self?.crashReporter.log(error: error)
                    }).disposed(by: self.bag)
                }
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error)
            }).disposed(by: self.bag)
        }
    }

    private func navigateToChat(_ completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let product = product else { return }
        chatService.getChatThread(filter: ThreadFilterKey.item, id: product.id)
            .subscribe(onNext: { [weak self] id in
                if let id = id {
                    self?.coordinator.openChatThread(threadID: id)
                }
                DispatchQueue.main.async {
                    completion?(.success(()))
                }
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                       withInfo: ["screen": "pdp", "type": "navigate_chat", "id": "\(product.id)"])
                self?.coordinator.showError(error)
                completion?(.failure(error))
            }).disposed(by: bag)
    }

    lazy var more = MoreAds(adID: adID,
                            repo: self.adRepo,
                            coordinator: self.coordinator)
}

extension AdDetailsViewModel {
    func canBid() -> Bool {
        guard let ad = product, let auction = ad.currentAuction, auction.minBid != nil else { return false }
        return true
    }

    func logBidEvent(source: AdBidSource) {
        var eventSource = BidSource.pdp
        switch source {
        case .ar:
            eventSource = BidSource.ar
        case .bidButton:
            eventSource = BidSource.pdp
        case .bidTopSection:
            eventSource = BidSource.pdpNoBidYet
        }
        bidSource = eventSource
        trackBidClicked(source: eventSource)
    }

    private func didStartBid(bid: Money) {
        if let source = bidSource {
            trackBid(source: source, bid: bid)
        }
    }
}

extension AdDetailsViewModel {
    func trackBid(source: BidSource, bid: Money) {
        guard let ad = product else { return }
        // Segment.io
        eventTrackingService.trackBid(ad: ad, bid: bid, source: source)
    }

    func trackSafeShoppingEvent() {
        eventTrackingService.ad.trackSafeShoppingBannerClicked()
    }

    func trackShareCompleted(activity: String) {
        guard let ad = product else { return }
        eventTrackingService.ad.trackShareCompleted(ad: ad,
                                                    shareNetwork: activity)
    }

    func trackShareClicked() {
        guard let ad = product else { return }
        eventTrackingService.ad.trackShareClicked(ad: ad)
    }

    func trackBuyNowClicked(source: BuyNowSource) {
        guard let ad = product else { return }
        let categoryText = ad.categoryList.map { $0.slug }.joined(separator: ",")
        eventTrackingService.trackAdDetailsBuyNow(ad: ad,
                                                  categoryText: categoryText,
                                                  source: source)
    }

    func trackBidClicked(source: BidSource) {
        guard let ad = product else { return }
        let categoryText = ad.categoryList.map { $0.slug }.joined(separator: ",")
        eventTrackingService.trackAdDetailsBid(ad: ad,
                                               categoryText: categoryText,
                                               maxBid: ad.auction?.highestBid?.amount.amount,
                                               source: source)
    }

    func trackAdViewed() {
        guard let ad = product else { return }
        eventTrackingService.trackAdViewed(ad: ad)
    }

    func trackPhotoViewed(id: UUID, isFullScreen _: Bool) {
        guard let ad = product else { return }
        eventTrackingService.trackPhotoViewed(ad: ad,
                                              photoID: id,
                                              isFullScreen: false)
    }

    func trackVideoViewed(isFullScreen _: Bool) {
        guard let ad = product else { return }
        eventTrackingService.trackVideoViewed(ad: ad,
                                              isFullScreen: false,
                                              page: .adDetails)
    }
}

struct MoreAds {
    
    private let adID: UUID
    private let repo: LegacyProductDetailsRepository
    private let coordinator: AdDetailsCoordinator
    var moreAds = PublishSubject<[AdViewModel]>()
    private let bag = DisposeBag()
    
    init(adID: UUID, repo: LegacyProductDetailsRepository, coordinator: AdDetailsCoordinator) {
        self.adID = adID
        self.repo = repo
        self.coordinator = coordinator
    }
    
    func onAdTapped(model: AdViewModel) {
        coordinator.showAd(id: model.id)
    }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction.BuyNowPrice: Price {}
extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction.MinimumBid: Price {}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.FullImage: Image {}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Auction: AuctionBasic {
    public var minBid: WhoppahCore.Price? { minimumBid }
    public var buyNowValue: Price? { buyNowPrice }
}

extension GraphQL.GetRelatedProductsQuery.Data.RelatedProduct: WhoppahCore.Product {
    public var image: [Image] {fullImages.map {$0}}
    
    public var video: [Video] {return []}
    
    public var price: Price? {currentAuction?.buyNowValue}
    
    public var ar: LegacyARObject? {return nil}
    
    public var favoriteId: UUID? {
        get {
            favorite?.id
        }
        set(newValue) {
            if let id = newValue {
                favorite = GraphQL.GetRelatedProductsQuery.Data.RelatedProduct.Favorite(id: id)
            } else {
                favorite = nil
            }
        }
    }
    
    public var badge: ProductBadge? {
        let res = attributes.compactMap { $0.asLabel }
        guard let label = res.first else { return nil }
        return ProductBadge(slug: label.slug, backgroundHex: label.color)
    }
    
    public var currentAuction: AuctionBasic? {auction }
}
