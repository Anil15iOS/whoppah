//
//  WPTextField+TextFieldText.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: WPTextField {
    internal var messageType: Binder<TextFieldText> {
        Binder(base) { view, data in
            switch data.type {
            case let .text(value):
                view.errorMessage = nil
                view.text = value
            case let .error(message, text):
                if let text = text {
                    view.text = text
                }
                view.errorMessage = message
            }
            view.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        }
    }
}
