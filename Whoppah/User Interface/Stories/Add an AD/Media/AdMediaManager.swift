//
//  AdMediaManager.swift
//  Whoppah
//
//  Created by Eddie Long on 21/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import Resolver
import UIKit

let adMediaProgress = Notification.Name("com.whoppah.app.create.media.progress")
let adPhotoUpdated = Notification.Name("com.whoppah.app.create.photo.updated")
let adVideoUpdated = Notification.Name("com.whoppah.app.create.video.updated")
let adMediaChanged = Notification.Name("com.whoppah.app.create.media.changed")
let adMediaError = Notification.Name("com.whoppah.app.create.media.error")

enum MediaSlot {
    case empty
    case image(photo: AdPhoto)
}

protocol MediaSnapshot {}
private struct AdMediaSnapshot: MediaSnapshot {
    let slots: [MediaSlot]
    let video: AdVideo?
}

class AdMediaManager {
    let maxImages = 15
    private let minImages = 5
    lazy var slots = [MediaSlot](repeating: .empty, count: maxImages)
    lazy var originalSlots = [Int: MediaSlot]()
    private(set) var videoSlot: AdVideo?

    private var snapshot: AdMediaSnapshot?

    @LazyInjected fileprivate var crashReporter: CrashReporter
    @LazyInjected fileprivate var adCreator: ADCreator
    @LazyInjected fileprivate var mediaCache: MediaCacheService
    @LazyInjected fileprivate var media: MediaService
    @LazyInjected fileprivate var apollo: ApolloService
    
    private var bag = DisposeBag()

    init() {}

    var firstEmptySlot: Int? {
        // find the first free slot
        slots.firstIndex(where: {
            switch $0 {
            case .empty: return true
            default: return false
            }
        })
    }

    var photoCount: Int {
        slots.reduce(0) { (result, slot) -> Int in
            if case .image = slot { return result + 1 }
            return result
        }
    }

    var maxPhotoSelectionAllowed: Int {
        maxImages - photoCount
    }

    var hasEnoughPhotos: Bool {
        photoCount >= minImages
    }

    var hasMaxPhotos: Bool {
        photoCount >= maxImages
    }

    var hasVideo: Bool {
        videoSlot != nil
    }

    var videoThumbnail: UIImage? {
        guard let videoData = videoSlot else { return nil }
        return videoData.thumb()
    }

    var firstImage: AdPhoto? {
        if case let .image(photo)? = slots.first {
            return photo
        }
        return nil
    }
}

// MARK: UI

extension AdMediaManager {
    func getPhoto(atPath path: IndexPath) -> AdPhoto? {
        guard path.row < slots.count else { return nil }
        guard case let .image(photo) = slots[path.row] else { return nil }
        return photo
    }

    func getOriginalPhoto(atPath path: IndexPath) -> AdPhoto? {
        guard path.row < slots.count else { return nil }
        guard case let .image(photo) = originalSlots[path.row] else { return nil }
        return photo
    }

    func getVideo() -> AdVideo? { videoSlot }

    func getSelectPhotoCellViewModel(_ row: Int) -> SelectPhotoMediaCellViewModel {
        guard row < slots.count else { fatalError("Fetching for row greater than number of slots available") }

        switch slots[row] {
        case .empty:
            fatalError("Fetching invalid media type")
        case let .image(photo):
            guard let image = photo.image() else {
                return SelectPhotoMediaCellViewModel(state: .loading, media: nil, count: "\(row + 1)")
            }
            return SelectPhotoMediaCellViewModel(state: .photo, media: image, count: "\(row + 1)")
        }
    }

    func getPhotoCellViewModel(_ row: Int) -> MediaCellViewModel? {
        guard row < slots.count else { return nil }
        switch slots[row] {
        case .empty:
            return MediaCellViewModel(state: .empty, selectable: false)
        case let .image(photo):
            guard let image = photo.image() else {
                return MediaCellViewModel(state: .loading, selectable: false)
            }
            return MediaCellViewModel(state: .photo(image: image), selectable: true)
        }
    }

    func getVideoCellViewModel(_: Int) -> MediaCellViewModel? {
        guard let video = videoSlot else { return nil }
        switch video {
        case let .new(data, thumbnail, path):
            return MediaCellViewModel(state: .video(thumb: thumbnail, video: data, path: path), selectable: true)
        case let .existing(_, data, thumbnail, path):
            return MediaCellViewModel(state: .video(thumb: thumbnail, video: data, path: path), selectable: true)
        }
    }

    private func getDraftCacheKey(forAd adId: UUID, type: CacheMediaType, atIndex: Int? = nil) -> String {
        let indexText = atIndex != nil ? "-\(atIndex!)" : ""
        return mediaCache.getCacheKey(identifier: "draft-\(adId.uuidString)\(indexText)", type: type)
    }

    private func fetchImages(forAd ad: AdTemplate, adId: UUID) {
        guard let images = ad.images else { return }
        guard !images.isEmpty else {
            // No server items, check for drafts
            for i in 0 ..< maxImages {
                let imageId = getDraftCacheKey(forAd: adId, type: .image, atIndex: i)
                guard mediaCache.hasCachedItem(identifier: imageId) else { break }
                mediaCache.fetchImage(identifier: imageId, url: nil, expirySeconds: nil) { [weak self] (result) -> Void in
                    switch result {
                    case let .success(fetchedImage):
                        guard let self = self else { return }
                        let adImage = AdPhoto.new(data: fetchedImage)
                        self.addPhoto(adImage)
                        NotificationCenter.default.post(name: adPhotoUpdated, object: nil, userInfo: ["position": index])
                    case let .failure(error):
                        NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "unable to load video media with error \(error)"])
                    }
                }
            }
            return
        }

        // For each image, fetch the image and update the local photos
        for (index, image) in images.enumerated() {
            // Ignore images without a url
            let adImage = AdPhoto.existing(id: image.id, data: nil)
            addPhoto(adImage)
            let url = URL(string: image.url)
            let imageId = mediaCache.getCacheKey(identifier: "\(image.id.uuidString)", type: .image)
            mediaCache.fetchImage(identifier: imageId, url: url, expirySeconds: userGeneratedContentDurationSeconds) { [weak self] (result) -> Void in
                switch result {
                case let .success(fetchedImage):
                    guard let self = self else { return }
                    let adImage = AdPhoto.existing(id: image.id, data: fetchedImage)
                    if self.updatePhoto(adImage) {
                        NotificationCenter.default.post(name: adPhotoUpdated, object: nil, userInfo: ["position": index])
                    }
                case let .failure(error):
                    NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "Unable to load image media with error \(error)"])
                }
            }
        }
    }

    private func fetchVideo(forAd ad: AdTemplate, adId: UUID) {
        guard let video = ad.videos?.first else {
            let videoId = getDraftCacheKey(forAd: adId, type: .video)
            guard mediaCache.hasCachedItem(identifier: videoId) else { return }
            mediaCache.fetchData(identifier: videoId, url: nil, expirySeconds: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    let videoThumbId = self.getDraftCacheKey(forAd: adId, type: .videoThumb)
                    guard self.mediaCache.hasCachedItem(identifier: videoThumbId) else { return }
                    self.mediaCache.fetchImage(identifier: videoThumbId, url: nil, expirySeconds: nil) { [weak self] (result) -> Void in
                        switch result {
                        case let .success(thumb):
                            DispatchQueue.main.async {
                                guard let self = self else { return }
                                let nsData = data as NSData
                                let videoResult = nsData.writeToURLSynchronous(named: "temporary-\(adId.uuidString).mov")
                                var videoUrl: URL?
                                if case let .success(url) = videoResult {
                                    videoUrl = url
                                }
                                let video = AdVideo.new(data: data, thumbnail: thumb, path: videoUrl)
                                self.addVideo(data: video)
                                NotificationCenter.default.post(name: adVideoUpdated, object: nil, userInfo: nil)
                            }
                        case let .failure(error):
                            NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "unable to load video media with error \(error)"])
                        }
                    }
                case let .failure(error):
                    NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "unable to load video media with error \(error)"])
                }
            }
            return
        }

        // Allow videos without thumbnails
        var newVideo = AdVideo.existing(id: video.id, data: nil, thumbnail: nil, path: nil /* ONLY DISPLAY LOCAL - video.asURL() */ )
        addVideo(data: newVideo)
        // First get the thumbnail
        let thumbUrl = URL(string: video.thumbnail)
        let videoThumbId = mediaCache.getCacheKey(identifier: "\(video.id.uuidString)", type: .videoThumb)
        mediaCache.fetchImage(identifier: videoThumbId, url: thumbUrl, expirySeconds: userGeneratedContentDurationSeconds) { [weak self] (result) -> Void in
            switch result {
            case let .success(thumb):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    // Use existing data (if present)
                    newVideo = AdVideo.existing(id: video.id, data: newVideo.data(), thumbnail: thumb, path: newVideo.url())
                    self.updateVideo(data: newVideo)
                    NotificationCenter.default.post(name: adVideoUpdated, object: nil, userInfo: nil)
                }
            case let .failure(error):
                NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "unable to load video media with error \(error)"])
            }
        }

        // Load main data
        mediaCache.loadVideo(video: video, expiry: defaultCacheDurationSeconds) { url in
            guard let url = url else { return }
            if url.isFileURL {
                do {
                    let data = try Data(contentsOf: url)
                    newVideo = AdVideo.existing(id: video.id, data: data, thumbnail: newVideo.thumb(), path: url)
                    self.updateVideo(data: newVideo)
                    NotificationCenter.default.post(name: adVideoUpdated, object: nil, userInfo: nil)
                } catch {
                    NotificationCenter.default.post(name: adMediaError, object: nil, userInfo: ["message": "unable to load video media with error \(error)"])
                }
            } else {
                newVideo = AdVideo.existing(id: video.id, data: nil, thumbnail: newVideo.thumb(), path: url)
                self.updateVideo(data: newVideo)
                NotificationCenter.default.post(name: adVideoUpdated, object: nil, userInfo: nil)
            }
        }
    }

    func fetchMedia(forAd ad: AdTemplate) {
        guard let adId = ad.id else { return }

        fetchImages(forAd: ad, adId: adId)
        fetchVideo(forAd: ad, adId: adId)
    }

    func cancel() {
        bag = DisposeBag()
    }
}

// MARK: Image upload/delete/recognition (server)

extension AdMediaManager {
    enum ImageUploadError: Error {
        case invalidFormat
        case missingFirstImage
    }

    private func uploadAndLinkImage(withPhoto photo: AdPhoto, atIndex index: Int, adId: UUID) -> Observable<AdPhoto> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.uploadImage(index: index, objectId: adId, photo: photo)
                .subscribe(onNext: { photo in
                    observer.onNext(photo)
                    observer.onCompleted()
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "create_ad", "type": "upload_image"])
                    observer.onError(error)
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    private func uploadAndLinkVideo(withVideo video: AdVideo, atIndex index: Int, adId: UUID) -> Observable<AdVideo> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.uploadVideo(index: index, objectId: adId, video: video)
                .subscribe(onNext: { video in
                    observer.onNext(video)
                    observer.onCompleted()
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error, withInfo: ["screen": "create_ad", "type": "upload_video"])
                    observer.onError(error)
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    func uploadAllMedia(adId: UUID) -> Observable<Void> {
        var observables = [Observable<Void>]()

        for (index, slot) in slots.enumerated() {
            switch slot {
            case let .image(photo):
                // Don't re-upload any photos that have made it up already
                if case .new = photo {
                    observables.append(uploadAndLinkImage(withPhoto: photo, atIndex: index, adId: adId)
                        .map { _ in () }
                        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))
                }
            default: break
            }
        }

        if let video = videoSlot {
            // Don't re-upload any videos that have made it up already
            if case .new = video {
                observables.append(uploadAndLinkVideo(withVideo: video, atIndex: 0, adId: adId)
                    .map { _ in () }
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))
            }
        }

        return Observable.create { (observer) -> Disposable in
            // Wait for all uploads to complete
            Observable.zip(observables)
                .subscribe(onError: { error in
                    observer.onError(error)
                }, onCompleted: {
                    self.purgeDraftMedia(id: adId)
                    observer.onCompleted()
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    private func uploadImage(index: Int, objectId: UUID, photo: AdPhoto) -> Observable<AdPhoto> {
        guard let jpeg = photo.image()?.jpegData(compressionQuality: 1.0) else { return Observable.error(ImageUploadError.invalidFormat) }
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            // Server index is 1-based :rolleyes:
            self.media.uploadImage(data: jpeg,
                                            contentType: GraphQL.ContentType.product,
                                            objectId: objectId,
                                            type: nil,
                                            position: index + 1)
                .subscribe(onNext: { [weak self] state in
                    guard let self = self else { return }
                    switch state {
                    case let .progress(obs):
                        obs.subscribe(onNext: { progress in
                            NotificationCenter.default.post(name: adMediaProgress, object: nil, userInfo: ["progress": progress])
                        }).disposed(by: self.bag)
                    case let .complete(id):
                        let mediaId = self.mediaCache.getCacheKey(identifier: "\(id.uuidString)", type: .image)
                        self.mediaCache.saveData(identifier: mediaId, data: jpeg, expirySeconds: userGeneratedContentDurationSeconds)
                        let photo = AdPhoto.existing(id: id, data: photo.image())
                        guard index < self.slots.count else { return }
                        self.slots[index] = .image(photo: photo)
                        observer.onNext(photo)

                        let query = GraphQL.ProductQuery(id: objectId, playlist: .hls)
                        self.apollo.updateCache(query: query) { (cachedQuery: inout GraphQL.ProductQuery.Data) in
                            // We just add in an empty url - we don't have one now (unless we somehow use the cache key)
                            let image = GraphQL.ProductQuery.Data.Product.FullImage(id: id, url: "")
                            if let images = cachedQuery.product?.fullImages {
                                if index < images.count {
                                    cachedQuery.product?.fullImages.insert(image, at: index)
                                } else {
                                    cachedQuery.product?.fullImages.append(image)
                                }
                            } else {
                                cachedQuery.product?.fullImages = [image]
                            }

                            let thumb = GraphQL.ProductQuery.Data.Product.Thumbnail(id: id, url: "")
                            if let images = cachedQuery.product?.thumbnails {
                                if index < images.count {
                                    cachedQuery.product?.thumbnails.insert(thumb, at: index)
                                } else {
                                    cachedQuery.product?.thumbnails.append(thumb)
                                }
                            } else {
                                cachedQuery.product?.thumbnails = [thumb]
                            }
                        }

                        observer.onCompleted()
                    }
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    private func deleteMedia(ad: AdTemplate, media: UUID) -> Observable<Void> {
        self.media.deleteProductMedia(id: media, objectId: ad.id!)
    }

    enum VideoUploadError: Error {
        case invalidFormat
    }

    fileprivate func uploadVideo(index: Int, objectId: UUID? = nil, video: AdVideo) -> Observable<AdVideo> {
        guard let thumb = video.thumb(), let thumbnail = thumb.jpegData(compressionQuality: 1.0), let videoData = video.data() else { return Observable.error(VideoUploadError.invalidFormat) }
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            // Server index is 1-based :rolleyes:
            self.media.uploadVideo(data: videoData,
                                            contentType: GraphQL.ContentType.product,
                                            objectId: objectId,
                                            position: index + 1)
                .subscribe(onNext: { [weak self] state in
                    guard let self = self else { return }
                    switch state {
                    case let .progress(obs):
                        obs.subscribe(onNext: { progress in
                            NotificationCenter.default.post(name: adMediaProgress, object: nil, userInfo: ["progress": progress])
                        }).disposed(by: self.bag)
                    case let .complete(id):
                        let videoId = self.mediaCache.getCacheKey(identifier: "\(id.uuidString)", type: .video)
                        self.mediaCache.saveData(identifier: videoId, data: videoData, expirySeconds: userGeneratedContentDurationSeconds)
                        let videoThumbId = self.mediaCache.getCacheKey(identifier: "\(id.uuidString)", type: .videoThumb)
                        self.mediaCache.saveData(identifier: videoThumbId, data: thumbnail, expirySeconds: userGeneratedContentDurationSeconds)
                        let video = AdVideo.existing(id: id, data: videoData, thumbnail: thumb, path: nil)
                        self.videoSlot = video
                        observer.onNext(video)
                        observer.onCompleted()
                    }
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error,
                                            withInfo: ["screen": "create_ad", "type": "upload_video"])
                    observer.onError(error)
                }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    func saveDraftMedia(id: UUID) {
        purgeDraftMedia(id: id)
        for i in 0 ..< maxImages {
            guard case let .image(photo) = slots[i] else { break }
            // Only care about new photos
            guard case .new = photo else { continue }
            guard let jpeg = photo.image()?.jpegData(compressionQuality: 100) else { continue }
            let mediaId = getDraftCacheKey(forAd: id, type: .image, atIndex: i)
            mediaCache.saveData(identifier: mediaId, data: jpeg, expirySeconds: nil)
        }

        if let video = videoSlot, case let .new(data, thumbnail, _) = video {
            let videoId = getDraftCacheKey(forAd: id, type: .video)
            mediaCache.saveData(identifier: videoId, data: data, expirySeconds: nil)
            let videoThumbId = getDraftCacheKey(forAd: id, type: .videoThumb)
            if let jpeg = thumbnail?.jpegData(compressionQuality: 100) {
                mediaCache.saveData(identifier: videoThumbId, data: jpeg, expirySeconds: nil)
            }
        }
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
    }

    func getDraftImageKeys(forId id: UUID) -> [String] {
        var draftKeys = [String]()
        for i in 0 ..< maxImages {
            let mediaId = getDraftCacheKey(forAd: id, type: .image, atIndex: i)
            if !mediaCache.hasCachedItem(identifier: mediaId) {
                break
            }
            draftKeys.append(mediaId)
        }
        return draftKeys
    }

    func getDraftVideoKeys(forId id: UUID) -> [String] {
        let mediaId = getDraftCacheKey(forAd: id, type: .video)
        if !mediaCache.hasCachedItem(identifier: mediaId) {
            return []
        }
        return [mediaId]
    }

    private func purgeDraftImage(forAd id: UUID, atIndex i: Int) {
        let mediaId = getDraftCacheKey(forAd: id, type: .image, atIndex: i)
        guard mediaCache.hasCachedItem(identifier: mediaId) else { return }
        mediaCache.removeData(identifier: mediaId)
    }

    private func purgeDraftVideo(forAd id: UUID) {
        let videoId = getDraftCacheKey(forAd: id, type: .video)
        guard mediaCache.hasCachedItem(identifier: videoId) else { return }
        mediaCache.removeData(identifier: videoId)
        let videoThumbId = getDraftCacheKey(forAd: id, type: .videoThumb)
        mediaCache.removeData(identifier: videoThumbId)
    }

    private func purgeDraftMedia(id: UUID) {
        for i in 0 ..< maxImages {
            purgeDraftImage(forAd: id, atIndex: i)
        }
        purgeDraftVideo(forAd: id)
    }

    private func imageExists(id: UUID) -> Bool {
        slots.contains(where: {
            if case let .image(photo) = $0 {
                if case let .existing(existingID, _) = photo {
                    return existingID == id
                }
            }
            return false
        })
    }
}

// MARK: Diff resolution

extension AdMediaManager {
    func getSnapshot() -> MediaSnapshot {
        AdMediaSnapshot(slots: slots, video: videoSlot)
    }

    func restoreSnapshot(_ snapshot: MediaSnapshot) {
        guard let snapshot = snapshot as? AdMediaSnapshot else { return }
        slots = snapshot.slots
        videoSlot = snapshot.video
    }

    func captureSnapshot() {
        snapshot = AdMediaSnapshot(slots: slots, video: videoSlot)
    }

    func clearSnapshot() {
        snapshot = nil
    }

    func resolveDiffs(ad: AdTemplate) -> Observable<Void> {
        let slotSnapshot = snapshot?.slots

        var observables = [Observable<Void>]()
        let maxLength = max(slots.count, slotSnapshot?.count ?? 0)
        for index in 0 ... maxLength {
            // For each slot go through the previous slots (at snapshot)
            var slot: MediaSlot?
            var previousSlot: MediaSlot?
            if index < slots.count { slot = slots[index] }
            if let previousSnapshot = slotSnapshot {
                if index < previousSnapshot.count { previousSlot = previousSnapshot[index] }
            }

            if let currentSlot = slot, let snapshopSlot = previousSlot {
                observables.append(resolveSlot(ad: ad, currentSlot: currentSlot, snapshopSlot: snapshopSlot, index: index)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))
            } else if let currentSlot = slot {
                observables.append(resolveCurrentOnlySlot(ad: ad, currentSlot, index: index)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))
            } else if let existingSlot = previousSlot {
                observables.append(resolveSnapshotOnlySlot(ad: ad, existingSlot)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))
            }
        }

        observables.append(resolveVideoDiffs(ad: ad)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive)))

        return Observable.create { (observer) -> Disposable in
            // Wait for all uploads to complete
            Observable.zip(observables).subscribe(onError: { error in
                observer.onError(error)
            }, onCompleted: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.syncSlotsWithServer(ad: ad).subscribe(onCompleted: {
                        if let id = ad.id { self.purgeDraftMedia(id: id) }
                        observer.onCompleted()
                    }).disposed(by: self.bag)
                }
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    /// Only current slot, no existing from before
    private func resolveCurrentOnlySlot(ad: AdTemplate, _ slot: MediaSlot, index: Int) -> Observable<Void> {
        Observable.create { (observer) -> Disposable in
            switch slot {
            case .empty:
                // nothing to do
                observer.onCompleted()
            case let .image(photo):
                if case .new = photo {
                    self.uploadImage(index: index, objectId: ad.id!, photo: photo).subscribe(onNext: { _ in
                        observer.onCompleted()
                    }, onError: { _ in
                        observer.onCompleted()
                    }).disposed(by: self.bag)
                } else { /* Nothing to do - it's just been shuffled */ }
            }
            return Disposables.create()
        }
    }

    /// Only existing slot, no slot in the same place now
    private func resolveSnapshotOnlySlot(ad: AdTemplate, _ slot: MediaSlot) -> Observable<Void> {
        Observable.create { (observer) -> Disposable in
            // there was a slot but now there isn't in the same position
            switch slot {
            case .empty:
                // nothing to do
                observer.onCompleted()
            case let .image(photo):
                if case let .existing(id, _) = photo {
                    // Does this ID existing in other slots? If not then we need to delete the media from the slot
                    if !self.imageExists(id: id) {
                        self.deleteMedia(ad: ad, media: id).subscribe(onNext: { _ in
                            observer.onCompleted()
                        }, onError: { _ in
                            observer.onCompleted()
                        })
                            .disposed(by: self.bag)
                    } else {
                        observer.onCompleted()
                        /* Nothing to do - it's just been shuffled */
                    }
                } else {
                    assertionFailure("Unexpected 'new' item in an existing slot")
                }
            }
            return Disposables.create()
        }
    }

    /// Exists an item in both the current and previous slots
    private func resolveSlot(ad: AdTemplate, currentSlot: MediaSlot, snapshopSlot: MediaSlot, index: Int) -> Observable<Void> {
        let observable: Observable<Void> = Observable.create { (observer) -> Disposable in
            switch currentSlot {
            case .empty:
                observer.onCompleted()
            case let .image(photo):
                switch photo {
                case .new:
                    self.uploadImage(index: index, objectId: ad.id!, photo: photo).subscribe(onNext: { _ in
                        observer.onCompleted()
                    }, onError: { error in
                        observer.onError(error)
                    })
                        .disposed(by: self.bag)
                case .existing:
                    // Nothing to do - it's just been shuffled
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }

        // This deletes objects that are gone (resolveSnapshotOnlySlot)
        return Observable.zip(resolveSnapshotOnlySlot(ad: ad, snapshopSlot), observable)
            .map { _ in () }
    }

    private func resolveVideoDiffs(ad: AdTemplate) -> Observable<Void> {
        let observable: Observable<Void> = Observable.create { (observer) -> Disposable in
            switch (self.videoSlot, self.snapshot?.video) {
            case let (.some(newSlot), .some(existingSlot)):
                switch newSlot {
                case .new:
                    self.uploadVideo(index: 0, objectId: ad.id!, video: newSlot).subscribe(onNext: { _ in
                        observer.onCompleted()
                    }, onError: { _ in
                        observer.onCompleted()
                    })
                        .disposed(by: self.bag)
                case let .existing(id, _, _, _):
                    guard case let .existing(existingId, _, _, _) = existingSlot else { fatalError() }
                    assert(existingId.uuidString == id.uuidString)
                    observer.onCompleted()
                }
            case (let .some(newSlot), nil):
                self.uploadVideo(index: 0, objectId: ad.id!, video: newSlot).subscribe(onNext: { _ in
                    observer.onCompleted()
                }, onError: { _ in
                    observer.onCompleted()
                })
                    .disposed(by: self.bag)
            case (nil, let .some(existing)):
                if case let .existing(id, _, _, _) = existing {
                    self.deleteMedia(ad: ad, media: id).subscribe(onNext: { _ in
                        observer.onCompleted()
                    }, onError: { _ in
                        observer.onCompleted()
                    })
                        .disposed(by: self.bag)
                } else {
                    fatalError("Expect existing slots to have an existing type")
                }
            default:
                observer.onCompleted()
            }
            return Disposables.create()
        }
        return observable
    }

    func syncSlotsWithServer(ad: AdTemplate) -> Observable<[Void]> {
        var observers = [Observable<Void>]()
        for (index, slot) in slots.enumerated() {
            switch slot {
            case let .image(photo):
                if case let .existing(imageId, _) = photo {
                    let observer = media.linkMediaToProduct(mediaId: imageId, objectId: ad.id!, position: index + 1)
                    observers.append(observer)
                } else {
                    crashReporter.log(event: "Expected all images to be uploaded", withInfo: [:])
                }
            default: break
            }
        }

        if let videoData = videoSlot {
            if case let .existing(videoId, _, _, _) = videoData {
                let observer = media.linkMediaToProduct(mediaId: videoId, objectId: ad.id!, position: 1)
                observers.append(observer)
            } else {
                assertionFailure("Expected all videos to be uploaded")
            }
        }

        return Observable.zip(observers)
    }
}

// MARK: Media moving, selection

extension AdMediaManager {
    func canSelectPhoto(_ row: Int) -> Bool {
        guard row < slots.count else { return false }
        switch slots[row] {
        case .empty:
            return false
        default: return true
        }
    }

    func movePhoto(from: Int, to: Int) {
        let slot = slots.remove(at: from)
        slots.insert(slot, at: to)
    }

    func canMovePhoto(at: Int) -> Bool {
        at < photoCount && at >= 0
    }

    func canMovePhoto(at: Int, to: Int) -> Bool {
        guard at != to else { return false }
        return canMovePhoto(at: at) && canMovePhoto(at: to)
    }
}

// MARK: Media addition, updating, deletion

extension AdMediaManager {
    func clearAllMedia() {
        slots.removeAll()
        slots = [MediaSlot](repeating: .empty, count: maxImages)
        originalSlots.removeAll()
        originalSlots = [Int: MediaSlot]()
        videoSlot = nil
        snapshot = nil
    }

    func addPhoto(_ photo: AdPhoto) {
        defer {
            NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
        }
        let newSlot = MediaSlot.image(photo: photo)
        guard let freeSlot = firstEmptySlot, freeSlot < slots.count else {
            slots.append(newSlot)
            return
        }

        slots[freeSlot] = newSlot
    }

    func replacePhoto(_ photo: AdPhoto, at: Int) {
        if originalSlots[at] == nil { originalSlots[at] = slots[at] }
        slots.remove(at: at)
        slots.insert(MediaSlot.image(photo: photo), at: at)
        NotificationCenter.default.post(name: adPhotoUpdated, object: nil, userInfo: ["position": index])
    }

    func updatePhoto(_ photo: AdPhoto) -> Bool {
        let index = slots.firstIndex { (slot) -> Bool in
            switch slot {
            case let .image(data):
                switch (photo, data) {
                case let (.existing(item1, _), .existing(item2, _)):
                    return item1 == item2
                default: return false
                }
            default: return false
            }
        }
        guard let idx = index, idx < slots.count else { return false }
        slots[idx] = MediaSlot.image(photo: photo)
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
        if let existing = snapshot {
            snapshot = AdMediaSnapshot(slots: slots, video: existing.video)
        }
        return true
    }

    func addVideo(data: AdVideo) {
        videoSlot = data
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
    }

    @discardableResult
    func updateVideo(data: AdVideo) -> Bool {
        videoSlot = data
        if let existing = snapshot {
            snapshot = AdMediaSnapshot(slots: existing.slots, video: videoSlot)
        }
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
        return true
    }

    func deletePhoto(atIndex index: Int, forAd adId: UUID? = nil) {
        guard index < slots.count else { return }
        if case let .image(photo) = slots[index] {
            if case .new = photo, let adId = adId {
                purgeDraftImage(forAd: adId, atIndex: index)
            }
            slots.remove(at: index)
            slots.append(.empty)
        }
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
    }

    func deleteVideo(forAd adId: UUID? = nil) {
        if let existing = videoSlot {
            if case .new = existing, let adId = adId {
                purgeDraftVideo(forAd: adId)
            }
            existing.removeTemporaryVideo()
        }
        videoSlot = nil
        NotificationCenter.default.post(name: adMediaChanged, object: nil, userInfo: nil)
    }
}
