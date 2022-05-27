//
//  FileCache.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/04/2022.
//

import Foundation
import SwiftUI

protocol FileCache {
    subscript(_ url: URL) -> URL? { get set }
}

private struct TemporaryFileCache: FileCache {
    private let cache: NSCache<NSURL, NSURL> = {
        let cache = NSCache<NSURL, NSURL>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    subscript(_ key: URL) -> URL? {
        get { cache.object(forKey: key as NSURL) as URL? }
        set { newValue == nil ?
            cache.removeObject(forKey: key as NSURL) :
            cache.setObject(newValue! as NSURL, forKey: key as NSURL)
        }
    }
}

struct FileCacheKey: EnvironmentKey {
    static let defaultValue: FileCache = TemporaryFileCache()
}

extension EnvironmentValues {
    var fileCache: FileCache {
        get { self[FileCacheKey.self] }
        set { self[FileCacheKey.self] = newValue }
    }
}
