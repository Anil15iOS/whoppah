//
//  Bundle.swift
//  Whoppah
//
//  Created by Eddie Long on 17/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int
}

extension Bundle {
    public static func isRunningTests() -> Bool {
        NSClassFromString("XCTestCase") != nil
    }

    public static func getVersion(forString version: String) -> Version? {
        let components = version.components(separatedBy: ".")
        guard components.count > 0, let major = Int(components[0]) else { return nil } // swiftlint:disable:this empty_count
        guard components.count > 1, let minor = Int(components[1]) else { return nil }
        guard components.count > 2, let patch = Int(components[2]) else { return nil }
        return Version(major: major, minor: minor, patch: patch)
    }

    public var versionString: String? {
        guard let versionStr = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        return versionStr
    }

    public func getVersion() -> Version? {
        guard let versionStr = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        return Bundle.getVersion(forString: versionStr)
    }
}
