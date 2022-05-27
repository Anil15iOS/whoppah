//
//  StoreService.swift
//  Whoppah
//
//  Created by Eddie Long on 30/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext

class StoreServiceImpl: StoreService {
    private lazy var session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

    // MARK: -

    func checkForUpdate(completion: @escaping (Result<AppUpdateRequirement, Error>) -> Void) {
        #if STAGING || TESTING
            let bundleId = "com.whoppah.app"
        #else
            guard let bundleId = Bundle.main.bundleIdentifier else { assertionFailure(); return }
        #endif
        guard let existingVersionStr = Bundle.main.versionString else { assertionFailure(); return }
        guard let existingVersion = Bundle.main.getVersion() else { assertionFailure(); return }
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=nl")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }
            let hasNew = self.hasNewVersion(existingVersionStr: existingVersionStr,
                                            existingVersion: existingVersion,
                                            data: data)
            completion(.success(hasNew))
        })
        dataTask.resume()
    }

    private func hasNewVersion(existingVersionStr _: String, existingVersion: Version, data: Data?) -> AppUpdateRequirement {
        guard let data = data else { return .none }
        guard let body = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap({ $0 as? [String: Any] }) else { return .none }
        guard let count = body["resultCount"] as? Int, count > 0 else { return .none } // swiftlint:disable:this empty_count
        guard let results = body["results"] as? [Any] else { return .none }
        guard !results.isEmpty, let resultSet = results[0] as? [String: Any] else { return .none }
        guard let versionStr = resultSet["version"] as? String else { return .none }
        guard let newVersion = Bundle.getVersion(forString: versionStr) else { return .none }
        guard newVersion.major > existingVersion.major else {
            guard newVersion.minor > existingVersion.minor else {
                return .none
            }
            return .nonBlocking
        }
        return .blocking
    }
}
