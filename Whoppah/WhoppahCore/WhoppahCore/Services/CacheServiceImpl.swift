//
//  CacheService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/5/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Resolver
import RxSwift

public class CacheServiceImpl: CacheService {
    // Ideally we would rely on the backend to help us here
    // With the Cache-Control and other headers
    enum SessionCachePolicy {
        case eternal // Cache is never invalided for a session
        case expirable(durationSeconds: TimeInterval) // The session cache is invalidated when an internal is reached
        case none
    }

    class SessionCache<T> {
        private var lock = NSRecursiveLock()
        private var data: T?
        private var expiryEpoch: TimeInterval = 0.0

        let policy: SessionCachePolicy

        init(policy: SessionCachePolicy) {
            self.policy = policy
        }

        func get() -> T? {
            lock.lock()
            // Achieves scoping
            defer { lock.unlock() }
            switch policy {
            case .eternal:
                return data
            case .expirable:
                if data != nil, expiryEpoch > 0.0 {
                    let timeSinceEpoch = Date().timeIntervalSince1970
                    let diff = expiryEpoch - timeSinceEpoch
                    if diff < 0 {
                        clear()
                        return nil
                    }
                }
                return data
            case .none:
                return nil
            }
        }

        func clear() {
            lock.lock()
            data = nil // Cache is invalid
            expiryEpoch = -1
            lock.unlock()
        }

        func set(value: T) {
            lock.lock()
            switch policy {
            case .eternal:
                data = value
            case let .expirable(expiryTimeSeconds):
                let interval = Date().timeIntervalSince1970
                expiryEpoch = interval + expiryTimeSeconds
                data = value
            default:
                break
            }
            lock.unlock()
        }
    }

    // MARK: - FAQ

    public var colors = [Color]()
    public var colorRepo: AdAttributeRepository?
    public var categoryRepo: CategoryRepository?
    public var brandRepo: AdAttributeRepository?
    public var artistRepo: AdAttributeRepository?
    public var designerRepo: AdAttributeRepository?
    public var materialRepo: AdAttributeRepository?

    private let bag = DisposeBag()
    
    public init() {
        colorRepo = RepositoryFactory.createAdAttributeRepo(type: .colors)
        colorRepo?.loadAttributes().subscribe(onNext: { [weak self] (colors: [Color]) in
            self?.colors = colors
        }).disposed(by: bag)

        categoryRepo = RepositoryFactory.createCategoryRepo()
        brandRepo = RepositoryFactory.createAdAttributeRepo(type: .brands)
        artistRepo = RepositoryFactory.createAdAttributeRepo(type: .artists)
        designerRepo = RepositoryFactory.createAdAttributeRepo(type: .designers)
        materialRepo = RepositoryFactory.createAdAttributeRepo(type: .materials)
    }
}
