//
//  TextFieldText.swift
//  Whoppah
//
//  Created by Eddie Long on 14/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

struct TextFieldText {
    var title: String {
        switch type {
        case let .text(value):
            return value
        case let .error(_, text):
            return text ?? ""
        }
    }

    var error: String? {
        if case let .error(message, _) = type {
            return message
        }
        return nil
    }

    enum MessageType {
        case text(value: String)
        case error(message: String, text: String? = nil)
    }

    let type: MessageType

    init(title: String) {
        type = .text(value: title)
    }

    init(error: String) {
        type = .error(message: error)
    }

    init(type: MessageType) {
        self.type = type
    }
}
