//
//  UIButton+Analytics.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import Resolver
import UIKit

protocol UIAnalytics {
    var analyticsKey: String { get set }
}

/**
 This is a temporary fix for the service provider that's used within a tap gesture recognizer.
 The original code had been set up with a global service provider var that was accessed
 throughout the application. This caused breaking issues on iOS 15. When integrating
 SwiftUI and composable architecture we'll write a clean solution for this.
 */
struct AnalyticsProvider {
    @Injected var eventTracking: EventTrackingService
}

@IBDesignable
extension UIViewController: UIAnalytics {
    private static var _analyticsKey = [String: String]()
    @IBInspectable var analyticsKey: String {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController._analyticsKey[tmpAddress] ?? ""
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController._analyticsKey[tmpAddress] = newValue
        }
    }
}

extension UIView: UIAnalytics {
    static var _screenKeyKey = [String: String]()
    var screenKey: String {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._screenKeyKey[tmpAddress] ?? ""
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._screenKeyKey[tmpAddress] = newValue
        }
    }

    static var _analyticsKeyInternal = [String: String]()
    @IBInspectable var _analyticsKey: String {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._analyticsKeyInternal[tmpAddress] ?? ""
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._analyticsKeyInternal[tmpAddress] = newValue
        }
    }

    func determineScreenkey() {
        guard screenKey.isEmpty == true else { return }
        var responder: UIResponder? = self as UIResponder
        while responder as? UIViewController == nil {
            if let next = responder?.next {
                responder = next
            } else {
                break
            }
        }

        if let vc = responder as? UIViewController {
            screenKey = vc.analyticsKey
        }

        if screenKey.isEmpty {
            if let respond = responder {
                screenKey = String(describing: type(of: respond))
            }
        }
    }

    func linkAnalyticsEvent() {
        if !analyticsKey.isEmpty {
            let tap = UITapGestureRecognizer(target: self, action: #selector(analyticsTap(_:)))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            addGestureRecognizer(tap)
        }
    }

    @objc func analyticsTap(_: UITapGestureRecognizer) {
        let key = analyticsKey
        guard !key.isEmpty else { return }
        determineScreenkey()
        let screen = screenKey.isEmpty ? "Unknown" : screenKey
        
        let analyticsProvider = AnalyticsProvider()
        analyticsProvider.eventTracking.trackButtonClick(key: key, screen: screen)
    }
}

extension UIView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        true
    }
}

@IBDesignable
extension UIButton {
    @IBInspectable override var analyticsKey: String {
        get {
            _analyticsKey
        }
        set(newValue) {
            _analyticsKey = newValue
            linkAnalyticsEvent()
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        linkAnalyticsEvent()
    }
}

// We can't have UIView have awakeFromNib called as we get various compiler errors
// Instead this needs to be a programatic event
extension UIView {
    @objc var analyticsKey: String {
        get {
            _analyticsKey
        }
        set(newValue) {
            _analyticsKey = newValue
            linkAnalyticsEvent()
        }
    }
}
