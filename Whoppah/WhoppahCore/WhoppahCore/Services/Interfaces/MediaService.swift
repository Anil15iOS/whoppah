//
//  MediaService.swift
//  Whoppah
//
//  Created by Eddie Long on 11/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCoreNext
import WhoppahDataStore

public enum MerchantImageType: String {
    case avatar
    case cover
}

public enum MediaUploadState<T> {
    case progress(state: Observable<HTTPProgress>)
    case complete(result: T)
}

public typealias ImageMediaUploadState = MediaUploadState<UUID>

public protocol MediaService {
    /// Uploads an image to the Whoppah backend
    ///
    /// - Parameter data The image raw data
    /// - Parameter contentType What content type this image is associated with
    /// - Parameter objectId The id of the content type that this image is associated with
    /// - Parameter type The 'type' of the image, such as 'avatar' or 'cover'
    /// - Parameter position The position of the image, only relevant for products (is 1-based)
    /// - Returns: An observable with the media upload state
    func uploadImage(data: Data, contentType: GraphQL.ContentType, objectId: UUID?, type: String?, position: Int?) -> Observable<ImageMediaUploadState>

    /// Uploads a video to the Whoppah backend
    ///
    /// - Parameter data The video raw data
    /// - Parameter contentType What content type this video is associated with
    /// - Parameter objectId The id of the content type that this video is associated with
    /// - Parameter position The position of the video, only relevant for products (is 1-based)
    /// - Returns: An observable with the media upload state
    func uploadVideo(data: Data, contentType: GraphQL.ContentType, objectId: UUID?, position: Int?) -> Observable<ImageMediaUploadState>

    /// Links a media item to a product
    ///
    /// - Parameter mediaId The server id of the media item
    /// - Parameter objectId The id of the object to link the media to
    /// - Parameter position The position that the media is linked to (is 1-based)
    /// - Returns: An observable without any data
    func linkMediaToProduct(mediaId: UUID, objectId: UUID, position: Int) -> Observable<Void>

    /// Delete product media
    ///
    /// - Parameter id The server id of the media item to delete
    /// - Parameter objectId The id of the object to delete the media from
    /// - Returns: An observable without any data
    func deleteProductMedia(id: UUID, objectId: UUID) -> Observable<Void>

    /// Delete the merchant media
    ///
    /// - Parameter id The server id of the media item to delete
    /// - Parameter type The 'type' of the media, e.g. 'avatar' or 'cover'
    /// - Parameter objectId The id of the merchant to delete the media from
    /// - Returns: An observable without any data
    func deleteMerchantMedia(id: UUID, type: MerchantImageType, objectId: UUID) -> Observable<Void>
}
