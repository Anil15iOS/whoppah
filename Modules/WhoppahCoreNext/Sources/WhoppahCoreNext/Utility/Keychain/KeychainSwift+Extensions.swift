//
//  KeychainSwift+Extensions.swift
//  WhoppahCoreNext
//
//  Created by Eddie Long on 19/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public extension KeychainSwift {
    private struct Keys {
        static let appId = "com.whoppah.app.identifier"
    }

    func set(_ value: Int, forKey key: String) {
        let valueToStore = "\(value)"
        set(valueToStore, forKey: key)
    }

    static func create(persistBetweenInstalls: Bool = false) -> KeychainSwift {
        // Prefix is important here so items in the keychain aren't persisted between installs
        guard !persistBetweenInstalls else {
            guard let bundle =  Bundle.main.bundleIdentifier else {
                return KeychainSwift(keyPrefix: Keys.appId)
            }
            return KeychainSwift(keyPrefix: bundle)
        }
        return KeychainSwift(keyPrefix: prefix)
    }

    static var prefix: String {
        // ===================================
        // NOTE: This is a unique UUID that is associated with the app install
        // It should never be removed or overwriten!!!
        // It is used as the prefix for Keychain items so they are unique for an app install
        // ===================================
        var appId = UserDefaults.standard.string(forKey: Keys.appId)
        if appId == nil {
            // Generate a new UUID
            appId = NSUUID().uuidString
            UserDefaults.standard.set(appId, forKey: Keys.appId)
        }
        return appId!
    }
}
