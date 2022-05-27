//
//  EmailClient.swift
//  Whoppah
//
//  Created by Eddie Long on 06/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

enum EmailClient: String, CaseIterable {
    case gmail = "googlegmail"
    case mail = "message"

    var url: URL! { URL(string: "\(rawValue)://")! }

    var title: String {
        switch self {
        case .gmail: return R.string.localizable.emailClientGmail()
        case .mail: return R.string.localizable.emailClientMail()
        }
    }

    func exists() -> Bool {
        UIApplication.shared.canOpenURL(url)
    }

    func open(_ completed: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(url, options: [:], completionHandler: completed)
    }
}
