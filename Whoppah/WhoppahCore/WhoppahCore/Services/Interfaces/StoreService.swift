//
//  StoreService.swift
//  Whoppah
//
//  Created by Eddie Long on 11/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum AppUpdateRequirement {
    case none
    case blocking
    case nonBlocking
}

public protocol StoreService {
    /// Checks whether an app update is available on the AppStore
    ///
    /// - Parameter completion Called with a Result type, true/false if there's an update available, Error in failure
    func checkForUpdate(completion: @escaping (Result<AppUpdateRequirement, Error>) -> Void)
}
