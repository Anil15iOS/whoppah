//
//  Deeplinkables.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct Deeplinkables: Deeplinkable {
    private let deeplinkables: [Deeplinkable]
    
    init() {
        deeplinkables = [
            GoogleDeeplink(),
            DeeplinkManagerDeeplink(),
            FacebookDeeplink(),
            StripeDeeplink()
        ]
    }
    
    func openURLContexts(_ contexts: Set<UIOpenURLContext>) {
        deeplinkables.forEach { $0.openURLContexts(contexts) }
    }
}
