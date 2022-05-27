//
//  ImageCacheService.swift
//  Whoppah
//
//  Created by Eddie Long on 04/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Cache
import Foundation
import Kingfisher
import WhoppahCore

class MediaCacheServiceImpl: MediaCacheService {
    private struct CacheMissError: Error {}
    private let storage: Storage<Data>
    private var pendingFetches = [URLSessionDataTask]()
    private let pendingFetchLock = NSLock()

    let urlSession = URLSession(configuration: URLSessionConfiguration.default)

    init() {
        // Temporary path is recommended for items that can be recovered
        // If iOS needs to purge space then we can redownload
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Media")
        let diskConfig = DiskConfig(
            // The name of disk storage, this will be used as folder name within directory
            name: "Whoppah-Disk-Cache",
            // Keep items around for 1 week
            expiry: .date(Date().addingTimeInterval(24 * 3600 * 7)),
            // Where to store the disk cache. If nil, it is placed in `cachesDirectory` directory.
            directory: path,
            // Data protection is used to store files in an encrypted format on disk and to decrypt them on demand
            protectionType: .complete
        )
        let memoryConfig = MemoryConfig(expiry: .never)
        let transformer = TransformerFactory.forCodable(ofType: Data.self)
        do {
            storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: transformer)
        } catch {
            fatalError("Unable to create storage")
        }
    }

    public func hasCachedItem(identifier: String) -> Bool {
        let res = try? storage.existsObject(forKey: identifier)
        return res ?? false
    }

    private func tryFetchFromDiskCache(identifier: String, completion: @escaping DataFetchCompletion) {
        if let hasObject = try? storage.existsObject(forKey: identifier), hasObject {
            storage.async.object(forKey: identifier) { result in
                switch result {
                case let .value(data):
                    completion(.success(data))
                case let .error(error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(CacheMissError()))
        }
    }

    func fetchImage(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping ImageFetchCompletion) {
        fetchData(identifier: identifier, url: url, expirySeconds: expirySeconds) { (result) -> Void in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(ImageFetchError.imageDecodeFailure))
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchData(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping DataFetchCompletion) {
        tryFetchFromDiskCache(identifier: identifier) { [weak self] (result) -> Void in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case let .failure(error):
                if error as? ImageFetchError != nil {
                    completion(.failure(error))
                } else if error as? CacheMissError != nil {
                    guard let url = url else { return completion(.failure(error)) }
                    var task: URLSessionDataTask?
                    task = self?.urlSession.dataTask(with: url) { [weak self] data, urlResponse, _ in
                        self?.pendingFetchLock.lock()
                        self?.pendingFetches.remove(task!)
                        self?.pendingFetchLock.unlock()
                        guard let data = data, !data.isEmpty else {
                            completion(.failure(ImageFetchError.noData))
                            return
                        }

                        if 200 ... 299 ~= (urlResponse as! HTTPURLResponse).statusCode {
                            self?.saveData(identifier: identifier, data: data, expirySeconds: expirySeconds)
                            completion(.success(data))
                        } else {
                            completion(.failure(ImageFetchError.httpStatusCode))
                        }
                    }
                    self?.pendingFetchLock.lock()
                    self?.pendingFetches.append(task!)
                    self?.pendingFetchLock.unlock()
                    task!.resume()
                } else {
                    completion(.failure(ImageFetchError.noData))
                }
            }
        }
    }

    func saveData(identifier: String, data: Data, expirySeconds: TimeInterval?) {
        let expiry = expirySeconds != nil ? Expiry.seconds(expirySeconds!) : nil
        storage.async.setObject(data, forKey: identifier, expiry: expiry) { result in
            switch result {
            case .error:
                break
            case .value:
                break
            }
        }
    }

    func cancelPendingDownloads() {
        pendingFetchLock.lock()
        let fetchCopy = pendingFetches
        pendingFetches.removeAll()
        pendingFetchLock.unlock()
        if !fetchCopy.isEmpty {
            for task in fetchCopy {
                task.cancel()
            }
        }
    }

    func loadVideo(video: Video, expiry: TimeInterval?, completion: @escaping ((URL?) -> Void)) {
        // Prefer the server URL if present
        if let url = URL(string: video.url) {
            return completion(url)
        }

        // Otherwise fetch the cached view, if it exists in the cache
        let key = getCacheKey(identifier: video.id.uuidString, type: .video)
        guard hasCachedItem(identifier: key) else { return completion(nil) }

        fetchData(identifier: key, url: nil, expirySeconds: expiry) { result in
            switch result {
            case let .success(data):
                let nsData = data as NSData
                // Videos need to be writen to disk for the media view to access
                nsData.writeToURL(named: "\(video.id.uuidString).mov") { result in
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(url):
                            completion(url)
                        case .failure:
                            completion(nil)
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func removeData(identifier: String) {
        try? storage.removeObject(forKey: identifier)
    }
}

extension MediaCacheServiceImpl {
    func getCacheKey(identifier: String, type: CacheMediaType) -> String {
        switch type {
        case .video:
            return "video-\(identifier)"
        case .videoThumb:
            return "video-thumb-\(identifier)"
        case .image:
            return "image-\(identifier)"
        }
    }
}
