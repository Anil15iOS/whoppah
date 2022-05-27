//
//  AdMediaManagerTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 06/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Resolver

@testable import Testing_Debug
@testable import WhoppahCore

class AdMediaManagerTests: XCTestCase {
    override class func setUp() {
        MockServiceInjector.register()
    }

    func testDefaults() {
        let mm = AdMediaManager()
        XCTAssertFalse(mm.hasVideo)
        XCTAssertFalse(mm.hasEnoughPhotos)
        XCTAssertFalse(mm.hasEnoughPhotos)
        XCTAssertEqual(mm.firstEmptySlot, 0)
        XCTAssertNil(mm.firstImage)
        XCTAssertEqual(mm.maxPhotoSelectionAllowed, ProductConfig.maxNumberImages)
        XCTAssertNil(mm.getVideo())
        XCTAssertNil(mm.getPhoto(atPath: IndexPath(row: 0, section: 0)))
    }

    func testAddEnoughPhotos() {
        let mm = AdMediaManager()
        let first = UUID()
        for i in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: i == 0 ? first : UUID(), data: nil))
            XCTAssertEqual(mm.maxPhotoSelectionAllowed, ProductConfig.maxNumberImages - (i + 1))
        }
        XCTAssertNotNil(mm.firstImage)
        if case .existing(let id, _) = mm.firstImage {
            XCTAssertEqual(id.uuidString, first.uuidString)
        } else {
            XCTFail()
        }

        let firstPhoto = mm.getPhoto(atPath: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(firstPhoto)
        if case .existing(let id, _) = firstPhoto {
            XCTAssertEqual(id.uuidString, first.uuidString)
        } else {
            XCTFail()
        }
        XCTAssertTrue(mm.hasEnoughPhotos)
        XCTAssertEqual(mm.photoCount, ProductConfig.minNumberImages)
        XCTAssertEqual(mm.maxPhotoSelectionAllowed, ProductConfig.maxNumberImages - ProductConfig.minNumberImages)
    }

    func testAddMaxPhotos() {
        let mm = AdMediaManager()
        for i in 0..<ProductConfig.maxNumberImages {
            mm.addPhoto(AdPhoto.new(data: UIImage()))
            XCTAssertNotNil(mm.getPhoto(atPath: IndexPath(row: i, section: 0)))
        }
        XCTAssertEqual(mm.photoCount, ProductConfig.maxNumberImages)
        XCTAssertTrue(mm.hasMaxPhotos)
        XCTAssertEqual(mm.maxPhotoSelectionAllowed, 0)
    }

    func testAddVideo() {
        let mm = AdMediaManager()
        let thumb = UIImage()
        mm.addVideo(data: AdVideo.existing(id: UUID(), data: nil, thumbnail: thumb, path: nil))
        XCTAssertNotNil(mm.videoSlot)
        XCTAssertNotNil(mm.videoThumbnail)
        XCTAssertTrue(mm.hasVideo)
        XCTAssertNotNil(mm.getVideo())

        mm.deleteVideo()

        XCTAssertNil(mm.videoSlot)
        XCTAssertNil(mm.videoThumbnail)
        XCTAssertFalse(mm.hasVideo)
        XCTAssertNil(mm.getVideo())
    }

    func testRemovePhotos() {
        let mm = AdMediaManager()
        let first = UUID()
        for i in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: i == 0 ? first : UUID(), data: nil))
            XCTAssertEqual(mm.maxPhotoSelectionAllowed, ProductConfig.maxNumberImages - (i + 1))
        }
        mm.deletePhoto(atIndex: 0)
        XCTAssertEqual(mm.photoCount, ProductConfig.minNumberImages - 1)
        // Remove all photos (and extra one)
        for _ in 0..<ProductConfig.minNumberImages {
            mm.deletePhoto(atIndex: 0)
        }
    }

    func testMoveFirstPhoto() {
        let mm = AdMediaManager()
        var photos = [UUID]()
        for i in 0..<ProductConfig.minNumberImages {
            photos.append(UUID())
            mm.addPhoto(AdPhoto.existing(id: photos[i], data: nil))
            XCTAssertEqual(mm.maxPhotoSelectionAllowed, ProductConfig.maxNumberImages - (i + 1))
        }
        XCTAssertFalse(mm.canMovePhoto(at: ProductConfig.minNumberImages))
        XCTAssertTrue(mm.canMovePhoto(at: 0))
        XCTAssertTrue(mm.canMovePhoto(at: 0, to: 1))
        XCTAssertFalse(mm.canMovePhoto(at: -1, to: 1))
        XCTAssertFalse(mm.canMovePhoto(at: 1, to: -1))
        XCTAssertFalse(mm.canMovePhoto(at: ProductConfig.minNumberImages, to: 1))
        XCTAssertFalse(mm.canMovePhoto(at: 1, to: ProductConfig.minNumberImages))
        mm.movePhoto(from: 0, to: 1)

        if case .existing(let id, _) = mm.getPhoto(atPath: IndexPath(row: 1, section: 0)) {
            XCTAssertEqual(photos[0].uuidString, id.uuidString)
        }

        if case .existing(let id, _) = mm.getPhoto(atPath: IndexPath(row: 0, section: 0)) {
            XCTAssertEqual(photos[1].uuidString, id.uuidString)
        }
    }

    func testMoveFirstPhotoToEnd() {
        let mm = AdMediaManager()
        var photos = [UUID]()
        for i in 0..<ProductConfig.minNumberImages {
            photos.append(UUID())
            mm.addPhoto(AdPhoto.existing(id: photos[i], data: nil))
        }
        // All photos are shuffled backwards
        mm.movePhoto(from: 0, to: ProductConfig.minNumberImages - 1)

        for i in 0..<ProductConfig.minNumberImages {
            if case .existing(let id, _) = mm.getPhoto(atPath: IndexPath(row: i, section: 0)) {
                XCTAssertEqual(photos[(i + 1) % ProductConfig.minNumberImages].uuidString, id.uuidString)
            }
        }
    }

    func testPhotoSelection() {
        let mm = AdMediaManager()
        for i in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: UUID(), data: nil))
            XCTAssertTrue(mm.canSelectPhoto(i))
        }
        XCTAssertFalse(mm.canSelectPhoto(ProductConfig.minNumberImages))
    }

    func testMediaClear() {
        let mm = AdMediaManager()
        for _ in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: UUID(), data: nil))
        }
        mm.addVideo(data: AdVideo.existing(id: UUID(), data: nil, thumbnail: nil, path: nil))
        XCTAssertTrue(mm.hasVideo)
        XCTAssertTrue(mm.hasEnoughPhotos)
        mm.clearAllMedia()
        XCTAssertFalse(mm.hasVideo)
        XCTAssertFalse(mm.hasEnoughPhotos)
        XCTAssertEqual(mm.photoCount, 0)
    }

    func testSnapshot() {
        let mm = AdMediaManager()
        for _ in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: UUID(), data: nil))
        }

        let snapshot = mm.getSnapshot()
        for _ in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: UUID(), data: nil))
        }
        mm.addVideo(data: AdVideo.existing(id: UUID(), data: nil, thumbnail: nil, path: nil))
        XCTAssertEqual(mm.photoCount, ProductConfig.minNumberImages * 2)
        mm.restoreSnapshot(snapshot)
        XCTAssertEqual(mm.photoCount, ProductConfig.minNumberImages)
        XCTAssertFalse(mm.hasVideo)
    }

    func testUpdatePhoto() {
        let mm = AdMediaManager()
        let first = UUID()
        let redImage = UIImage(color: .red)!
        for i in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: i == 0 ? first : UUID(), data: redImage))
        }
        let blueImage = UIImage(color: .lightBlue)!
        let randomImage = AdPhoto.existing(id: UUID(), data: nil)
        XCTAssertFalse(mm.updatePhoto(randomImage))
        XCTAssertTrue(mm.updatePhoto(AdPhoto.existing(id: first, data: blueImage)))
        let replacedImage = mm.getPhoto(atPath: IndexPath(row: 0, section: 0))
        guard case .existing(_, let data) = replacedImage else { XCTFail(); return }
        XCTAssertEqual(data, blueImage)
    }

    func testUpdateVideo() {
        let mm = AdMediaManager()
        let videoId = UUID()
        mm.addVideo(data: AdVideo.existing(id: videoId, data: nil, thumbnail: nil, path: nil))
        let data = Data(base64Encoded: "ABCDEFG")
        let url = URL(string: "https://whoppah.com")
        let thumb = UIImage()
        mm.updateVideo(data: AdVideo.existing(id: videoId, data: data, thumbnail: thumb, path: url))
        guard let video = mm.getVideo() else { XCTFail(); return }
        switch video {
        case .existing(_, let existingData, let existingThumbnail, let existingPath):
            XCTAssertEqual(data, existingData)
            XCTAssertEqual(url, existingPath)
            XCTAssertEqual(thumb, existingThumbnail)
        default: XCTFail()
        }
    }

    func testDraftSaving() throws {
        let mediaCacheService: MediaCacheService = Resolver.resolve()
        let mediaCache = try XCTUnwrap(mediaCacheService as? MockMediaCacheService)
        let mm = AdMediaManager()
        for _ in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.existing(id: UUID(), data: nil))
        }
        let adId = UUID()
        mm.saveDraftMedia(id: adId)
        // ONLY 'new' photos are allowed - expect no saved draft media
        XCTAssertTrue(mm.getDraftImageKeys(forId: adId).isEmpty)
        // Clear for the next run
        mm.clearAllMedia()

        let redImage = UIImage(color: .red)!
        mediaCache.fetchImage = redImage
        mediaCache.cacheKey = "something-draft"
        for _ in 0..<ProductConfig.minNumberImages {
            mm.addPhoto(AdPhoto.new(data: redImage))
        }
        let data = Data(base64Encoded: "VGVzdA==")!
        let url = URL(string: "https://whoppah.com")
        let thumb = UIImage()

        mm.addVideo(data: AdVideo.new(data: data, thumbnail: thumb, path: url))
        mm.saveDraftMedia(id: adId)
        XCTAssertEqual(mm.getDraftImageKeys(forId: adId).count, ProductConfig.minNumberImages)
        XCTAssertEqual(mm.getDraftVideoKeys(forId: adId).count, 1)

        // Deleting without an ad ID doesn't work (because caching needs the ad ID)
        mm.deletePhoto(atIndex: 0)
        mm.deleteVideo()
        XCTAssertEqual(mm.getDraftImageKeys(forId: adId).count, ProductConfig.minNumberImages)
        XCTAssertFalse(mm.getDraftVideoKeys(forId: adId).isEmpty)
    }
}
