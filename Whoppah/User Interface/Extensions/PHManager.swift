//
//  PHManager.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Photos
import UIKit

extension PHImageManager {
    typealias ImageFetched = ((Int, UIImage?) -> Void)
    typealias ImagesFetched = (([UIImage]) -> Void)

    func fetchImages(assets: [PHAsset], imageFetched: ImageFetched?, completion: ImagesFetched?) {
        guard !assets.isEmpty else { completion?([]); return }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        var fetchedImages = [UIImage]()
        var totalProcessed = 0
        let handlePhotoFetched = { (index: Int, image: UIImage?) in
            totalProcessed += 1
            imageFetched?(index, image)
            if let image = image {
                fetchedImages.append(image)
            }
            guard totalProcessed == assets.count else { return }
            completion?(fetchedImages)
        }
        for (index, asset) in assets.enumerated() {
            requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                var image: UIImage?
                if let data = data {
                    image = UIImage(data: data)
                }
                handlePhotoFetched(index, image)
            }
        }
    }
}
