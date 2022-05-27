//
//  Localizable.swift
//  Whoppah
//
//  Created by Eddie Long on 17/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol Localizable {
    var localized: String? { get }
}

extension String: Localizable {
    var localized: String? {
        localizedString(self)
    }
}

func localizedString(_ key: String?, placeholder: String? = nil, logError: Bool = true) -> String? {
    guard let key = key else { return nil }
    let res = NSLocalizedString(key, value: "", comment: "")
    #if DEBUG
        if logError, res.isEmpty || res == key {
            print("String '\(key)' NOT FOUND **")
        }
    #endif
    if res.isEmpty || res == key {
        return placeholder
    }
    return res
}

/// Collection of registered strings. String = string key.
private var registerStringIds = [String: BehaviorSubject<String?>]()

/// These are strings that are no present in the inital app bundle
/// When our backend service for delivery strings (currently Lokalise) updates
/// We update the subject here and publish any changes
/// This allows the relevant UI etc. to update without any extra mechanics in place
func observedLocalizedString(_ key: String?, placeholder: String? = nil) -> Observable<String?> {
    guard let key = key, !key.isEmpty else { return Observable.just(nil) }
    if let found = registerStringIds[key] {
        return found
    }

    let res = NSLocalizedString(key, value: "", comment: "")
    if res.isEmpty || key == res {
        var value = placeholder
        #if DEBUG || STAGING || TESTING 
            if placeholder == nil {
                value = key
            }
            print("Missing text key \(key) - queueing up for fetching. Placeholder: \(value ?? "")")
        #endif
        let observer = BehaviorSubject<String?>(value: value)
        registerStringIds[key] = observer
        return observer
    }
    let observer = BehaviorSubject<String?>(value: res)
    registerStringIds[key] = observer
    return observer
}

func onStringsLoaded() {
    for item in registerStringIds {
        let res = NSLocalizedString(item.key, value: "", comment: "")
        if !res.isEmpty, item.key != res {
            #if DEBUG
                print("Fetched text key \(item.key) with a value of \(res)")
            #endif
            item.value.onNext(res)
        }
    }
}
