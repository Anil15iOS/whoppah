//
//  Localizable+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 17/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

protocol UILocalizable {
    var l8nKey: String? { get set }
}

@IBDesignable
extension UILabel: UILocalizable {
    @IBInspectable var l8nKey: String? {
        get {
            nil
        }
        set(key) {
            if let localized = key?.localized, localized.containsHtml() {
                setHtml(localized)
            } else {
                text = key?.localized
            }
            syncWithIB()
        }
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        syncWithIB()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        syncWithIB()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        syncWithIB()
    }

    private func syncWithIB() {
        if let localizationKey = l8nKey {
            text = localizedString(localizationKey)
        }
    }
}

@IBDesignable
extension UIButton: UILocalizable {
    @IBInspectable var l8nKey: String? {
        get { nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

@IBDesignable
extension UINavigationBar: UILocalizable {
    @IBInspectable var l8nKey: String? {
        get { nil }
        set(key) {
            topItem?.title = key?.localized
        }
    }
}

@IBDesignable
extension UIViewController: UILocalizable {
    @IBInspectable var l8nKey: String? {
        get { nil }
        set(key) {
            title = key?.localized
        }
    }
}
