//
//  RecognitionService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

public typealias RecognitionImageUploadState = MediaUploadState<Recognition>

public protocol RecognitionService {
    /// Uploads an image to the Whoppah backend for image recognition
    ///
    /// - Parameter data The image raw data
    /// - Returns: An observable with the media upload state
    func uploadImage(data: Data) -> Observable<RecognitionImageUploadState>
}
