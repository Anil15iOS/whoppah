//
//  WPTextField+Rx.swift
//  Whoppah
//
//  Created by Eddie Long on 31/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: WPTextField {
    var placeholder: Binder<String> {
        Binder(base) { view, text in
            view.placeholder = text
        }
    }

    var errorMessage: Binder<String?> {
        Binder(base) { view, text in
            view.errorMessage = text
        }
    }

    var error: Binder<Bool> {
        Binder(base) { view, error in
            view.hasError = error
        }
    }
}
