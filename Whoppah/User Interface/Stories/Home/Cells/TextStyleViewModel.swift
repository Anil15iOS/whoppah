//
//  TextStyleViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 24/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

class TextStyleViewModel {
    struct NotificationName {
        static let didFetchText = Notification.Name("text.style.did_update")
    }

    private let style: Style
    private let bag = DisposeBag()

    private let _title = BehaviorSubject<String>(value: "")
    init(style: Style) {
        self.style = style

        observedLocalizedString(styleTitleKey(style.slug))
            .compactMap { $0?.capitalized }
            .subscribe(onNext: { [weak self] text in
                self?._title.onNext(text)
                NotificationCenter.default.post(name: NotificationName.didFetchText, object: nil)
            })
            .disposed(by: bag)
    }

    var text: BehaviorSubject<String> { _title }
}
