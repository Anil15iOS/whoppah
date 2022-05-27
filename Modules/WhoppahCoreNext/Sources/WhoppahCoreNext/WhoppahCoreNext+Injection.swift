//
//  WhoppahCoreNext+Injection.swift
//  
//
//  Created by Dennis Ippel on 30/11/2021.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerWhoppahCoreServices() {
        lazy var inAppNotifier: InAppNotifier = {
            InAppNotifier()
        }()
        register { inAppNotifier }
    }
}
