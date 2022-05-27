//
//  MediaCacheService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum ImageFetchError: Error {
    case noData
    case httpStatusCode
    case imageDecodeFailure
}

public enum CacheMediaType {
    case video
    case videoThumb
    case image
}

public let defaultCacheDurationSeconds: TimeInterval = 60 * 60 * 24 * 10 // 10 days
// Should be enough for the server to process the asset
public let userGeneratedContentDurationSeconds: TimeInterval = 60 * 5 // 5 minutes

public protocol MediaCacheService {
    typealias ImageFetchCompletion = ((Swift.Result<UIImage, Error>) -> Void)
    typealias DataFetchCompletion = ((Swift.Result<Data, Error>) -> Void)

    /// Fetch data with identifier with fetch of resource (and caching) if cache is missed
    ///
    /// - Parameter identifier The key to store the image in the cache
    /// - Parameter url The url to use to fetch the image if there's a cache miss (nil if there's no url - operating locally)
    /// - Parameter expirySeconds How long before the cache expires (set to nil if it never expires)
    /// - Parameter completion Callback on fetch completion
    func fetchImage(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping ImageFetchCompletion)

    /// Fetch data with identifier with fetch of resource (and caching) if cache is missed
    ///
    /// - Parameter identifier The key to store the image in the cache
    /// - Parameter url The url to use to fetch the image if there's a cache miss (nil if there's no url - operating locally)
    /// - Parameter expirySeconds How long before the cache expires (set to nil if it never expires)
    /// - Parameter completion Callback on fetch completion
    func fetchData(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping DataFetchCompletion)

    /// Save data into the cache with a given identifier
    ///
    /// - Parameter identifier The key to store the image in the cache
    /// - Parameter data The data to save
    /// - Parameter expirySeconds How long before the cache expires (set to nil if it never expires)
    func saveData(identifier: String, data: Data, expirySeconds: TimeInterval?)

    /// Cancel any pending downloads
    func cancelPendingDownloads()

    /// Checks if an item exists in the cache with the given identifer
    ///
    /// - Parameter identifier The identifier of the cache item
    /// - Returns: true if the item exists, false otherwise
    func hasCachedItem(identifier: String) -> Bool

    /// Gets a cache key back for the given media type (always non-draft items)
    ///
    /// - Parameter identifier The identifier of the cache item
    /// - Parameter type The type of data for the key
    /// - Returns: The cache key which can be used for fetching or storing data
    func getCacheKey(identifier: String, type: CacheMediaType) -> String

    /// Removes an item from the cache)
    ///
    /// - Parameter identifier The identifier of the cache item
    func removeData(identifier: String)

    /// Loads a video item from the cache
    ///
    /// - Parameter video The video to load
    /// - Parameter expiry The expiry period (in seconds) to store any downloaded video
    /// - Parameter completion Callback on fetch completion
    func loadVideo(video: Video, expiry: TimeInterval?, completion: @escaping ((URL?) -> Void))
}
