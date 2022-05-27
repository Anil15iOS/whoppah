//
//  HTTPProgress.swift
//  WhoppahCoreNext
//
//  Created by Eddie Long on 30/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct HTTPProgress {
    public let id: UUID
    public let request: URL
    public let fraction: Double
    public let totalDownloaded: Int64
    public let totalSizeBytes: Int64

    public init(id: UUID, request: URL, fraction: Double, totalDownloaded: Int64, totalSizeBytes: Int64) {
        self.id = id
        self.request = request
        self.fraction = fraction
        self.totalDownloaded = totalDownloaded
        self.totalSizeBytes = totalSizeBytes
    }
}
