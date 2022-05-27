//
//  FacebookDeeplink.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import FacebookCore
import UIKit

struct FacebookDeeplink: Deeplinkable {
    func openURLContexts(_ contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url,
              url.scheme == "fb533158663794438"
        else { return }
        
        ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url,
                sourceApplication: nil,
                annotation: [UIApplication.OpenURLOptionsKey.annotation]
            )
    }
}
