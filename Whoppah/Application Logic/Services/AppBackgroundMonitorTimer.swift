//
//  AppBackgroundMonitorTimer.swift
//  Whoppah
//
//  Created by Eddie Long on 05/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

class AppBackgroundMonitorTimer {
    var lastBackgrounding: TimeInterval?
    private let targetInterval: TimeInterval
    typealias OnTimerFired = () -> Void
    let callback: OnTimerFired

    init(interval: TimeInterval, callback: @escaping OnTimerFired) {
        targetInterval = interval
        self.callback = callback

        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func willResignActive() {
        lastBackgrounding = Date().timeIntervalSince1970
    }

    @objc private func didBecomeActive() {
        if let last = lastBackgrounding {
            let now = Date().timeIntervalSince1970
            let diff = now - last
            if diff > targetInterval {
                callback()
            }
        }
        lastBackgrounding = nil
    }
}
