//
//  StripeDeeplink.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import Stripe
import UIKit

struct StripeDeeplink: Deeplinkable {
    func openURLContexts(_ contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url else { return }
        StripeAPI.handleURLCallback(with: url)
    }
}
