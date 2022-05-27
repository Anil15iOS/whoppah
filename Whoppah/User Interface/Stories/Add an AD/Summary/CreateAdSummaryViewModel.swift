//
//  CreateAnAdSummaryViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 24/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import Resolver

class CreateAdSummaryViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdSummaryCoordinator
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var crashReporter: CrashReporter
    private let bag = DisposeBag()

    var mediaCount: Int { adCreator.mediaManager.photoCount + (adCreator.mediaManager.hasVideo ? 1 : 0) }
    struct Inputs {}

    struct Outputs {
        let saving = PublishSubject<Bool>()

        var title: Observable<String> { _title.asObservable() }
        fileprivate let _title = BehaviorRelay<String>(value: "")

        var description: Observable<String> { _description.asObservable() }
        fileprivate let _description = BehaviorRelay<String>(value: "")

        struct Media {
            var images: Observable<[MediaCellViewModel]> { _images.asObservable() }
            fileprivate let _images = BehaviorRelay<[MediaCellViewModel]>(value: [])

            var videos: Observable<[MediaCellViewModel]> { _videos.asObservable() }
            fileprivate let _videos = BehaviorRelay<[MediaCellViewModel]>(value: [])
        }

        let media = Media()

        struct Details {
            var brandOrArtist: Observable<String> { _brandOrArtist.asObservable() }
            fileprivate let _brandOrArtist = BehaviorRelay<String>(value: "")

            var materials: Observable<String> { _materials.asObservable() }
            fileprivate let _materials = BehaviorRelay<String>(value: "")

            var condition: Observable<String> { _condition.asObservable() }
            fileprivate let _condition = BehaviorRelay<String>(value: "")

            var dimensions: Observable<String> { _dimensions.asObservable() }
            fileprivate let _dimensions = BehaviorRelay<String>(value: "")

            var colors: Observable<[ColorViewModel]> { _colors.asObservable() }
            fileprivate let _colors = BehaviorRelay<[ColorViewModel]>(value: [])
        }

        let details = Details()

        struct Price {
            var asking: Observable<String> { _asking.asObservable() }
            fileprivate let _asking = BehaviorRelay<String>(value: "")

            var total: Observable<String> { _total.asObservable() }
            fileprivate let _total = BehaviorRelay<String>(value: "")

            var biddingEnabled: Observable<String> { _biddingEnabled.asObservable() }
            fileprivate let _biddingEnabled = BehaviorRelay<String>(value: "")
        }

        let price = Price()

        struct Shipping {
            var address: Observable<String> { _address.asObservable() }
            fileprivate let _address = BehaviorRelay<String>(value: "")

            var method: Observable<String> { _method.asObservable() }
            fileprivate let _method = BehaviorRelay<String>(value: "")
        }

        let shipping = Shipping()

        var nextButtonDescriptionVisible: Observable<Bool> { _nextButtonDescriptionVisible.asObservable() }
        fileprivate let _nextButtonDescriptionVisible = BehaviorRelay<Bool>(value: true)

        var nextButton: Observable<String> { _nextButton.asObservable() }
        fileprivate let _nextButton = BehaviorRelay<String>(value: "")

        var nextEnabled: Observable<Bool> { _nextEnabled.asObservable() }
        fileprivate let _nextEnabled = BehaviorRelay<Bool>(value: false)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdSummaryCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)

        registerNotifications()
        setupAd()
    }

    func refreshData() {
        setupAd()
    }

    func editPhotos() {
        coordinator.editPhotos()
        eventTracking.createAd.trackSummaryAdjustPhotos()
    }

    func editVideo() {
        coordinator.editVideo()
        eventTracking.createAd.trackSummaryAdjustVideo()
    }

    func editDescription() {
        coordinator.editDescription()
        eventTracking.createAd.trackSummaryAdjustDescription()
    }

    func editDetails() {
        coordinator.editDetails()
        eventTracking.createAd.trackSummaryAdjustDetails()
    }

    func editPrice() {
        coordinator.editPrice()
        eventTracking.createAd.trackSummaryAdjustPrice()
    }

    func editShipping() {
        coordinator.editShipping()
        eventTracking.createAd.trackSummaryAdjustDelivery()
    }

    func next() {
        uploadAd()
    }

    func onDismiss() {
        eventTracking.createAd.trackBackPressedAdCreation()
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMediaVideo), name: adPhotoUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMediaVideo), name: adVideoUpdated, object: nil)
    }

    var brandOrArtistTitle: String {
        guard let template = adCreator.template else { return "" }
        if hasArtCategory(template.categories) {
            return R.string.localizable.commonArtistTitle()
        } else {
            return R.string.localizable.commonBrandTitle()
        }
    }

    private func setupAd() {
        refreshMediaVideo()

        guard let template = adCreator.template else { return }
        outputs._title.accept(template.title ?? "")
        outputs._description.accept(template.description ?? "")

        if hasArtCategory(template.categories) {
            let text = template.artists.map { $0.title }.joined(separator: ",")
            outputs.details._brandOrArtist.accept(text.isEmpty ? "-" : text)
        } else {
            outputs.details._brandOrArtist.accept(template.brand?.title ?? "-")
        }
        // let materials = template.materials?.compactMap { localizedString(materialTitleKey($0.slug)) }.joined(separator: ",") ?? "-"
        // outputs.details._materials.accept(materials.isEmpty ? "-" : materials)
        outputs.details._condition.accept(template.quality?.title() ?? "-")

        let dimensions = [template.width, template.height, template.depth].compactMap { $0 }.map { "\($0)cm" }
        let dimensionText = dimensions.joined(separator: " x ")
        outputs.details._dimensions.accept(dimensionText.isEmpty ? "-" : dimensionText)

        outputs.details._colors.accept(template.colors?.map { ColorViewModel(color: $0, selected: false) } ?? [])

        outputs.price._asking.accept(template.price?.formattedPrice(includeCurrency: true) ?? "-")
        var totalText: String?
        if let member = user.current, let price = template.price {
            let totals = getAdTotals(price: price, member: member)
            totalText = totals?.total
        }
        outputs.price._total.accept(totalText ?? "-")
        let bidText = template.settings.allowBidding ? R.string.localizable.common_yes_button() : R.string.localizable.common_no_button()
        outputs.price._biddingEnabled.accept(bidText)

        let addressText = template.location?.formattedAddress(separator: "\n") ?? "-"
        outputs.shipping._address.accept(addressText)
        var methodText: String?
        if let method = template.delivery {
            switch method {
            case .pickup:
                methodText = R.string.localizable.createAdSummaryShippingPickupOnly()
            case .delivery:
                methodText = R.string.localizable.createAdSummaryShippingDeliveryOnly()
            case .pickupDelivery:
                methodText = R.string.localizable.createAdSummaryShippingDeliveryOrPickup()
            default: break
            }
        }

        outputs.shipping._method.accept(methodText ?? "-")

        // 6/3/2020 Some products are created in the CMS which are incomplete
        // Or perhaps they were using an older version of the app that had different validation
        // I suggested that we keep the validation here but highlight the section that is missing info
        // But instead it was requested to just allow the save button always in the summary screen
        /* switch adCreator.validate(step: .all) {
         case .none:
             outputs._nextEnabled.accept(true)
         default:
             // Show error somehow?!
             outputs._nextEnabled.accept(false)
         } */
        outputs._nextEnabled.accept(true)

        let state = adCreator.template?.state ?? .draft
        switch state {
        case .draft, .curation, .rejected:
            outputs._nextButton.accept(R.string.localizable.create_ad_main_btn_save())
            outputs._nextButtonDescriptionVisible.accept(true)
        default:
            outputs._nextButton.accept(R.string.localizable.createAdSummarySaveButton())
            outputs._nextButtonDescriptionVisible.accept(false)
        }
    }

    @objc private func refreshMediaVideo() {
        guard let mediaManager = adCreator.mediaManager else { return }

        var cells = [MediaCellViewModel]()
        let mediaCount = mediaManager.photoCount
        if mediaCount > 0 {
            for i in 0 ... mediaCount - 1 {
                guard let cell = mediaManager.getPhotoCellViewModel(i) else { continue }
                cells.append(cell)
            }
        }
        outputs.media._images.accept(cells)

        if mediaManager.hasVideo {
            if let videoCell = mediaManager.getVideoCellViewModel(0) {
                outputs.media._videos.accept([videoCell])
            }
        }
    }

    private func uploadAd() {
        trackPlaceAd()

        outputs.saving.onNext(true)

        let firstPhoto = adCreator.mediaManager.firstImage
        adCreator.finish().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.outputs.saving.onNext(false)
            let productImage = firstPhoto?.image() ?? R.image.image_placeholder()!
            guard let id = self.adCreator.template?.id else { return }
            self.coordinator.onAdCreateFinished(productImage: productImage, adID: id, mode: result)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.crashReporter.log(error: error, withInfo: ["screen": "create_ad", "type": "finish_creating"])
            self.outputs.saving.onNext(false)
            self.coordinator.showError(error)
        }).disposed(by: bag)
    }
}

extension CreateAdSummaryViewModel {
    func trackPlaceAd() {
        guard let userId = user.current?.mainMerchant.id else { return }
        guard let template = adCreator.template else { return }
        eventTracking.trackPlaceAd(userID: userId,
                                   price: template.price?.amount,
                                   category: template.categories.first?.slug,
                                   isBrand: template.brand != nil,
                                   deliveryType: template.delivery?.rawValue,
                                   photosCount: adCreator.mediaManager.photoCount,
                                   hasVideo: adCreator.mediaManager.hasVideo)
    }
}
