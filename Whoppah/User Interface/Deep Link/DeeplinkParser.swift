//
//  DeeplinkParser.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/31/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class DeeplinkParser {
    func parseDeepLink(_ url: URL) -> Navigator.Route {
        Navigator.getRoute(forUrl: url)
    }
}
