//
//  AdVideo.swift
//  Whoppah
//
//  Created by Eddie Long on 11/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

enum AdVideo {
    /// New - not yet uploaded to the server
    case new(data: Data, thumbnail: UIImage?, path: URL?)
    /// Already exists on the server, may not have data downloaded yet
    case existing(id: UUID, data: Data?, thumbnail: UIImage?, path: URL?)

    func thumb() -> UIImage? {
        switch self {
        case let .new(_, thumb, _):
            return thumb
        case let .existing(_, _, thumb, _):
            return thumb
        }
    }

    func id() -> UUID? {
        switch self {
        case .new:
            return nil
        case let .existing(id, _, _, _):
            return id
        }
    }

    func url() -> URL? {
        switch self {
        case let .new(_, _, url):
            return url
        case let .existing(_, _, _, url):
            return url
        }
    }

    func data() -> Data? {
        switch self {
        case let .new(data, _, _):
            return data
        case let .existing(_, data, _, _):
            return data
        }
    }

    func removeTemporaryVideo() {
        guard case let .new(_, _, url) = self else { return }
        if let temporaryPath = url {
            let path = temporaryPath.absoluteString
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {}
            }
        }
    }
}
