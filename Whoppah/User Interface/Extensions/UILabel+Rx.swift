//
//  UILabel+Rx.swift
//  Whoppah
//
//  Created by Eddie Long on 12/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        Binder(base) { view, textColor in
            view.textColor = textColor
        }
    }
}
