//
//  FirebaseCrashlyticsReporter.swift
//  Whoppah
//
//  Created by Dennis Ippel on 01/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import FirebaseCrashlytics

struct FirebaseCrashlyticsReporter: CrashReporter {
    var userId: String? {
        didSet {
            guard let userId = userId, !userId.isEmpty else {
                return
            }
            #if !PRODUCTION
            Crashlytics.crashlytics().setUserID(userId)
            #endif
        }
    }
    
    var enabled: Bool = true
    
    func log(event: String, withInfo info: [String : Any]?) {
        guard enabled else { return }
        
        if let attributes = info {
            Crashlytics.crashlytics().log("\(event) - \(attributes)")
        } else {
            Crashlytics.crashlytics().log(event)
        }
    }
    
    func log(error: Error, withInfo info: [String : Any]?, file: String, line: Int, function: String) {
        guard enabled else { return }
        
        var reportedError: Error = error
        
        if let underlyingError = (error as? GenericUserError)?.underlyingError {
            reportedError = underlyingError
        }
        
        Crashlytics.crashlytics().record(error: reportedError)
        Crashlytics.crashlytics().log("Crash log from \(file) on line \(line) called from function \(function)")
        if let extraInfo = info {
            Crashlytics.crashlytics().log(extraInfo.description)
        }
    }
}
