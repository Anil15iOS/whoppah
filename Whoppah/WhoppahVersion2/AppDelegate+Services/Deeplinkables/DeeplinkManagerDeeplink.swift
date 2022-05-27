//
//  DeeplinkManagerDeeplink.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct DeeplinkManagerDeeplink: Deeplinkable {
    func openURLContexts(_ contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url,
              url.scheme == "whoppah"
        else { return }

        DeeplinkManager.shared.handleDeeplink(url: url)
    }
}
