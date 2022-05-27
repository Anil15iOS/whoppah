//
//  ProductDetails+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

extension ProductDetails {
    var supportsAR: Bool {
        guard Device.supportsAR() else { return false }
        guard getARType(ar, size: [width, height]) != nil else { return false }
        return true
    }

    func getImages() -> [AdImageData] {
        var imageList = [AdImageData]()
        originalImages.forEach { image in
            imageList.append(AdImageData.server(id: image.id, preview: image, full: image))
        }

        previewImages.forEach { image in
            let index = imageList.firstIndex { existing -> Bool in
                switch existing {
                case let .server(id, _, _):
                    return id == image.id
                default: return false
                }
            }

            if let foundIndex = index {
                guard case let .server(_, _, full) = imageList[foundIndex] else { return }
                imageList[foundIndex] = AdImageData.server(id: image.id, preview: image, full: full)
            } else {
                imageList.append(AdImageData.server(id: image.id, preview: image, full: image))
            }
        }

        return imageList
    }

    func getDraftImages(id: UUID, mediaManager: AdMediaManager) -> [AdImageData] {
        let keys = mediaManager.getDraftImageKeys(forId: id)
        return keys.map { .draft(adId: id, cacheKey: $0) }
    }

    func getVideos() -> [AdVideoData] {
        productVideos.map { AdVideoData.server(video: $0) }
    }

    func getDraftVideos(id: UUID, mediaManager: AdMediaManager) -> [AdVideoData] {
        let keys = mediaManager.getDraftVideoKeys(forId: id)
        return keys.map { .draft(adId: id, cacheKey: $0) }
    }
}
