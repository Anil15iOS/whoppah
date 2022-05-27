//
//  AdImageData.swift
//  Whoppah
//
//  Created by Eddie Long on 12/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

enum AdImageData {
    case server(id: UUID, preview: Image, full: Image)
    case draft(adId: UUID, cacheKey: String)
}
