//
//  ADCreator.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/4/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class ADCreatorImpl: ADCreator {
    // MARK: - Properties

    var template: AdTemplate?
    var mediaManager: AdMediaManager!

    var mode: AdCreationMode = .none

    private var bag = DisposeBag()
    
    @LazyInjected private var crashReporter: CrashReporter
    @LazyInjected private var inAppNotifier: InAppNotifier
    @LazyInjected private var user: WhoppahCore.LegacyUserService
    @LazyInjected private var apollo: ApolloService
    @LazyInjected private var eventTracking: EventTrackingService
    @LazyInjected private var ads: ADsService

    public init() {
        mediaManager = AdMediaManager()
    }

    // MARK: -

    func startCreating() {
        template = AdTemplate()
        mediaManager.clearAllMedia()
        mode = .create(data: nil)

        mediaManager.clearSnapshot()
    }

    func startEditing(_ template: AdTemplate) {
        self.template = template
        mode = .edit

        mediaManager.clearAllMedia()
        mediaManager.fetchMedia(forAd: template)
        mediaManager.captureSnapshot()
    }

    func saveDraft() -> Observable<AdCreationResult> {
        switch mode {
        case .edit: return updateDraft()
        default: return saveNewDraft()
        }
    }

    private func saveNewDraft() -> Observable<AdCreationResult> {
        guard case let .create(existingData) = mode else { fatalError() }
        let merchantId = user.current!.merchantId
        let currency = user.current!.mainMerchant.currency
        let ad = template!
        return Observable.create { observer in
            var observable: Observable<GraphQL.CreateProductMutation.Data.CreateProduct>!
            if let existingData = existingData {
                observable = Observable.just(existingData)
            } else {
                // Price is required for ad creation
                if self.template?.price == nil {
                    self.template?.price = PriceInput(currency: currency, amount: 0)
                }
                let input = GraphQL.CreateProductMutation(input: ad.getInput(merchantId: merchantId),
                                                          playlist: GraphQL.PlaylistType.hls)
                observable = self.apollo.apply(mutation: input).compactMap { $0.data?.createProduct }
            }
            observable.subscribe(onNext: { [weak self] product in
                guard let self = self else { return }
                self.mode = .create(data: product)
                self.template?.id = product.id

                self.mediaManager.saveDraftMedia(id: product.id)
                self.cancelCreating()
                // Post message so the lists update
                self.inAppNotifier.notify(.adCreated)

                switch product.state {
                case .curation:
                    observer.onNext(.curation)
                case .accepted:
                    observer.onNext(AdCreationResult.created)
                case .draft, .updated, .rejected, .banned, .canceled, .archive: // What do we do here??
                    observer.onNext(AdCreationResult.created)
                case .__unknown:
                    observer.onNext(AdCreationResult.created)
                }
                observer.onCompleted()

            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "create_ad", "type": "create_draft"])
                observer.onError(error)
            }).disposed(by: self.bag)

            return Disposables.create()
        }
    }

    private func updateDraft() -> Observable<AdCreationResult> {
        let ad = template!

        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let merchantId = self.user.current!.merchantId
            let input = GraphQL.UpdateProductMutation(id: ad.id!,
                                                      input: ad.getInput(merchantId: merchantId))
            self.apollo.apply(mutation: input)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    guard let data = result.data else {
                        observer.onError(AdCreationError.incompleteData)
                        return
                    }

                    self.mediaManager.saveDraftMedia(id: data.updateProduct.id)
                    self.cancelCreating()
                    self.inAppNotifier.notify(.adUpdated)

                    switch result.data?.updateProduct.state ?? .curation {
                    case .curation:
                        observer.onNext(.curation)
                    case .accepted:
                        observer.onNext(AdCreationResult.created)
                    case .draft, .rejected, .banned, .canceled, .updated, .archive: // What do we do here??
                        observer.onNext(AdCreationResult.created)
                    case .__unknown:
                        observer.onNext(AdCreationResult.created)
                    }
                    observer.onCompleted()
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "create_ad", "type": "update_draft"])
                    observer.onError(error)
                }).disposed(by: self.bag)

            return Disposables.create()
        }
    }

    func finish() -> Observable<AdCreationResult> {
        bag = DisposeBag()
        switch mode {
        case .edit:
            return finishAdEdit()
        case let .create(existingData):
            return finishAdCreate(existingData)
        case .none:
            assertionFailure()
            return finishAdCreate(nil)
        }
    }

    private func finishAdEdit() -> Observable<AdCreationResult> {
        let ad = template!

        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let merchantId = self.user.current!.merchantId
            let input = GraphQL.UpdateProductMutation(id: ad.id!, input: ad.getInput(merchantId: merchantId))
            self.apollo.apply(mutation: input)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    guard let data = result.data else {
                        observer.onError(AdCreationError.incompleteData)
                        return
                    }

                    let template = self.template

                    self.mediaManager.resolveDiffs(ad: template!)
                        .subscribe(onError: { [weak self] error in
                            self?.crashReporter.log(error: error,
                                                    withInfo: ["screen": "create_ad", "type": "resolve_diffs"])
                            observer.onError(error)
                        }, onCompleted: { [weak self] in
                            guard let self = self else { return }
                            self.mediaManager.clearSnapshot()
                            switch data.updateProduct.state {
                            case .draft, .rejected:
                                self.publishAd(id: data.updateProduct.id, observer: observer)
                            default:
                                self.onAdPublished(data.updateProduct.state, observer: observer)
                            }
                        }).disposed(by: self.bag)

                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "create_ad", "type": "update_ad"])
                    observer.onError(error)
                }).disposed(by: self.bag)

            return Disposables.create()
        }
    }

    func cancelPendingUploads() {
        bag = DisposeBag()
        mediaManager.cancel()
    }

    private func finishAdCreate(_ existingData: GraphQL.CreateProductMutation.Data.CreateProduct?) -> Observable<AdCreationResult> {
        let merchantId = user.current!.merchantId
        let ad = template!
        return Observable.create { observer in
            var observable: Observable<GraphQL.CreateProductMutation.Data.CreateProduct>!
            if let existingData = existingData {
                observable = Observable.just(existingData)
            } else {
                let input = GraphQL.CreateProductMutation(input: ad.getInput(merchantId: merchantId), playlist: GraphQL.PlaylistType.hls)
                observable = self.apollo.apply(mutation: input).compactMap { $0.data?.createProduct }
            }
            observable.subscribe(onNext: { [weak self] product in
                guard let self = self else { return }
                self.mode = .create(data: product)
                if let merchant = self.user.current?.merchantId {
                    // Segment.io
                    let category: String = ad.getDeprecatedCategoryText()
                    self.eventTracking.trackAdUploaded(
                        adID: product.id,
                        userID: merchant,
                        price: product.buyNowPrice?.amount,
                        category: category,
                        isBrand: product.attributes.compactMap { $0.asBrand as? BrandAttribute }.isEmpty == false,
                        deliveryType: product.deliveryMethod.rawValue,
                        photosCount: self.mediaManager.photoCount,
                        hasVideo: self.mediaManager.hasVideo
                    )
                }
                self.template?.id = product.id

                self.mediaManager.uploadAllMedia(adId: product.id).subscribe(onError: { error in
                    observer.onError(error)
                }, onCompleted: { [weak self] in
                    guard let self = self else { return }
                    guard let template = self.template else {
                        self.mediaManager.clearSnapshot()
                        self.publishAd(id: product.id, observer: observer)
                        return
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.mediaManager.syncSlotsWithServer(ad: template).subscribe(onError: { error in
                            observer.onError(error)
                        }, onCompleted: { [weak self] in
                            self?.mediaManager.clearSnapshot()
                            self?.publishAd(id: product.id, observer: observer)
                        }).disposed(by: self.bag)
                    }
                }).disposed(by: self.bag)

            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error,
                                        withInfo: ["screen": "create_ad", "type": "create_ad"])
                observer.onError(error)
            }).disposed(by: self.bag)

            return Disposables.create()
        }
    }

    private func onAdPublished(_ state: GraphQL.ProductState, observer: AnyObserver<AdCreationResult>) {
        var adCreateResult = AdCreationResult.created
        switch mode {
        case .create:
            adCreateResult = AdCreationResult.created
            inAppNotifier.notify(.adCreated)
        case .edit:
            adCreateResult = AdCreationResult.edited
            inAppNotifier.notify(.adUpdated)
        default: break
        }

        switch state {
        case .curation:
            observer.onNext(.curation)
        case .accepted:
            observer.onNext(adCreateResult)
        case .draft, .rejected, .banned, .canceled, .updated, .archive: // What do we do here??
            observer.onNext(adCreateResult)
        case .__unknown:
            observer.onNext(adCreateResult)
        }
        observer.onCompleted()
        template = nil
        mode = .none
    }

    private func publishAd(id: UUID, observer: AnyObserver<AdCreationResult>) {
        ads.publishAd(id: id).subscribe(onNext: { [weak self] state in
            guard let state = state, let self = self else { return }
            self.onAdPublished(state, observer: observer)
        }, onError: { [weak self] error in
            self?.crashReporter.log(error: error,
                                    withInfo: ["screen": "create_ad", "type": "publish_ad"])
            observer.onError(error)
        }).disposed(by: bag)
    }

    func cancelCreating() {
        bag = DisposeBag()
        template = nil
        mediaManager.clearAllMedia()
        mode = .none
    }

    func validate(step: AdValidationSequenceStep?) -> AdValidationError {
        let requestedStep = step ?? .all
        guard let template = template else { return .description(reason: .title) }

        // Description
        if requestedStep == .description || requestedStep == .all {
            guard let title = template.title, !title.isEmpty else {
                return .description(reason: .title)
            }
            guard let description = template.description, !description.isEmpty else {
                return .description(reason: .description)
            }
        }

        if requestedStep == .photos || requestedStep == .all {
            // Photos (server side)
            if let images = template.images, images.count < ProductConfig.minNumberImages, !mediaManager.hasEnoughPhotos {
                // Check draft photos for this ad
                if let id = template.id {
                    if mediaManager.getDraftImageKeys(forId: id).count < ProductConfig.minNumberImages {
                        return .photos
                    }
                } else {
                    return .photos
                }
            }
        }

        // Video
        // Nothing for video currently

        // Details
        if requestedStep == .details || requestedStep == .all {
            // 4/3/2020 - A user who sets the brand to be unknown gets back an empty brand
            // So editing an ad the save button is disabled unless the user re-selects 'unknown'
            /* if template.category?.isArt == true {
                 guard !template.artists.isEmpty else { return .details(reason: .brandOrArtist) }
             } else {
                 guard template.brand != nil else { return .details(reason: .brandOrArtist) }
             } */
            guard template.quality != nil else { return .details(reason: .quality) }
            let dimensions = [template.width, template.height, template.depth].compactMap { $0 }
            guard !dimensions.isEmpty else { return .details(reason: .dimensions) }
            guard template.colors?.isEmpty == false else { return .details(reason: .colors) }
        }

        // Price
        if requestedStep == .price || requestedStep == .all {
            guard let price = template.price, price.amount.isValidSellerPrice() else { return .price(reason: .asking) }
            if template.settings.allowBidding {
                guard let minBid = template.settings.minBid, minBid.amount >= price.amount * ProductConfig.minimumBidLowestPercentage, minBid.amount <= price.amount else {
                    return .price(reason: .minBid)
                }
            }
        }

        // Shipping
        if requestedStep == .shipping || requestedStep == .all {
            guard let method = template.delivery else { return .shipping(reason: .method) }
            guard template.location != nil else { return .shipping(reason: .address) }
            if method != .pickup {
                guard template.shippingMethod != nil else { return .shipping(reason: .shipping) }
            }
        }
        return .none
    }
}
