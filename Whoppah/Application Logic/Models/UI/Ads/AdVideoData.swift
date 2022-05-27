//
//  AdVideoData.swift
//  Whoppah
//
//  Created by Eddie Long on 04/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

enum AdVideoData {
    case server(video: Video)
    case draft(adId: UUID, cacheKey: String)
}
