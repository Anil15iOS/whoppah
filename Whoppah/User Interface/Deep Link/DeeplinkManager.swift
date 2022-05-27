//
//  DeepLinkManager.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/31/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

class DeeplinkManager {
    // MARK: - Properties

    static let shared = DeeplinkManager()

    private let parser = DeeplinkParser()
    private var route = Navigator.Route.unknown

    // MARK: - Initialization

    private init() {}

    // MARK: -

    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        route = parser.parseDeepLink(url)
        return hasPendingDeepLink()
    }

    func executeDeeplink() {
        if case .unknown = route { return }
        Navigator().navigate(route: route)
        route = .unknown
    }

    func hasPendingDeepLink() -> Bool {
        if case .unknown = route { return false }
        return true
    }
}
