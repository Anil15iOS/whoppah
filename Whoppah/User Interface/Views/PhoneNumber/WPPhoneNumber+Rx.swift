//
//  WPPhoneNumber+Rx.swift
//  Whoppah
//
//  Created by Eddie Long on 12/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: WPPhoneNumber {
    internal var messageType: Binder<TextFieldText> {
        Binder(base) { view, data in
            switch data.type {
            case let .text(value):
                view.borderColor = nil
                view.textfield.set(phoneNumber: value)
            case let .error(_, text):
                if let text = text {
                    view.textfield.text = text
                }
                view.borderColor = R.color.redInvalidLight()
            }
            view.textfield.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        }
    }
}
