//
//  GoogleDeeplink.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

struct GoogleDeeplink: Deeplinkable {
    func openURLContexts(_ contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url,
              url.scheme == "893420819731-qkc36j46ui5e1si5d51b1iut2ln8fmru.apps.googleusercontent.com"
        else { return }
        
        GIDSignIn.sharedInstance().handle(url as URL?)
    }
}
